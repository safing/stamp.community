RSpec.feature 'flag stamp requests', type: :request do
  # :authorize calls :public_send on the fitting Policy
  # this is easier to stub than :authorize, which would not raise an error
  # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
  shared_context 'user is authorized' do
    before do
      allow_any_instance_of(Stamp::FlagPolicy).to(receive(:public_send).and_return(true))
    end
  end

  shared_context 'user is unauthorized' do
    before do
      allow_any_instance_of(Stamp::FlagPolicy).to(receive(:public_send).and_return(false))
    end
  end

  describe 'authentication & authourization' do
    describe '#new' do
      subject(:request) { get new_flag_stamp_path(app_id: some_app.id) }
      # IMPORTANT: 'app' as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end

    describe '#create' do
      subject(:request) { post(flag_stamp_index_url, params: { flag_stamp: stamp_attributes }) }

      # IMPORTANT: 'app' as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }
      let(:stamp_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:flag_stamp)
                  .merge(
                    app_id: some_app.id,
                    prompt_group: :prompt # must be set
                  )
      end

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
      end
    end

    describe '#show' do
      subject(:request) { get flag_stamp_path(stamp) }
      let(:stamp) { FactoryBot.create(:flag_stamp) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end
  end

  describe 'activities' do
    describe '#create' do
      include_context 'login user'
      include_context 'user is authorized'

      subject(:request) { post(flag_stamp_index_url, params: { flag_stamp: stamp_attributes }) }

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
