RSpec.feature 'stamp requests', type: :request do
  describe 'authentication & authourization' do
    describe '#new' do
      subject(:request) { get new_label_stamp_path(domain_name: domain.name) }
      let(:domain) { FactoryBot.create(:domain) }

      context 'role: guest' do
        include_examples 'status code', 403
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end

    describe '#create' do
      subject(:request) { post label_stamp_index_path, params: { label_stamp: stamp_attributes } }
      let(:domain) { FactoryBot.create(:domain) }
      let(:stamp_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:label_stamp)
                  .merge(
                    comments_attributes: { '0': { content: '1' * 40 } },
                    domain: domain.name
                  )
      end

      context 'role: guest' do
        include_examples 'status code', 403
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 302
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 302
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 302
      end
    end

    describe '#show' do
      subject(:request) { get label_stamp_path(stamp) }

      let(:stamp) { FactoryBot.create(:label_stamp) }

      context 'role: guest' do
        include_examples 'status code', 200
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end
  end

  describe 'activities' do
    describe 'Stamp::Label#create' do
      include_context 'login user'

      subject(:request) { post label_stamp_index_url, params: { label_stamp: stamp_attributes } }

      let(:domain) { FactoryBot.create(:domain) }
      let(:stamp_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:label_stamp)
                  .merge(
                    comments_attributes: { '0': { content: '1' * 40 } },
                    domain: domain.name
                  )
      end

      it "creates a 'stamp.create' activity with {owner: current_user, recipient: stampable}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq('stamp.create')
          expect(activity.owner).to eq(controller.current_user)
          expect(activity.recipient).to eq(domain)
        end
      end
    end

    describe 'Stamp::Flag#create' do
      include_context 'login admin'

      subject(:request) { post(flag_stamp_index_url, params: { flag_stamp: stamp_attributes }) }

      let(:admin) { FactoryBot.create(:admin, flag_stamps: true) }
      # IMPORTANT: 'app' as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }
      let(:stamp_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:flag_stamp)
                  .merge(
                    app_id: some_app.id,
                    prompt_group: :prompt # must be set
                  )
      end

      it "creates a 'stamp.create' activity with {owner: current_user, recipient: stampable}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq('stamp.create')
          expect(activity.owner).to eq(controller.current_user)
          expect(activity.recipient).to eq(some_app)
        end
      end
    end
  end
end
