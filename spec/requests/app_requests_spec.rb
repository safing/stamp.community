RSpec.feature 'app requests', type: :request do
  describe 'authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(AppPolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(AppPolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#new' do
      subject(:request) { get new_app_url }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
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
      subject(:request) { post apps_url, params: { app: app_attributes } }
      let(:app_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:app)
      end

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
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
      subject(:request) { get app_path(some_app) }

      # IMPORTANT: 'app' as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
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
  end

  describe 'activities' do
    describe '#create' do
      subject(:request) { post apps_url, params: { app: app_attributes } }

      let(:admin) { FactoryBot.create(:admin, flag_stamps: true) }
      let(:app_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:app)
      end

      include_context 'login admin'

      it "creates an 'app.create' activity with {owner: current_user}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(controller.current_user).to eq(activity.owner)
        end
      end
    end
  end
end
