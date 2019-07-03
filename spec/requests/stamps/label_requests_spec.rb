RSpec.feature 'label stamp requests', type: :request do
  describe 'authentication & authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(Stamp::LabelPolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(Stamp::LabelPolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#new' do
      subject(:request) { get new_label_stamp_path(domain_name: domain.name) }
      let(:domain) { FactoryBot.create(:domain) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
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

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
      end
    end

    describe '#show' do
      subject(:request) { get label_stamp_path(stamp) }
      let(:stamp) { FactoryBot.create(:label_stamp) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 200
      end

      context 'user is authenticated' do
        include_context 'login user'
        include_examples 'status code', 200
      end
    end
  end

  describe 'activities' do
    describe '#create' do
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
  end
end
