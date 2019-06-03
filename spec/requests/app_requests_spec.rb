RSpec.feature 'app requests', type: :request do
  describe 'authourization' do
    describe '#new' do
      subject(:request) { get new_app_url }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 401
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 401
      end

      context 'role: admin' do
        let(:admin) { FactoryBot.create(:admin, flag_stamps: flag_stamps) }
        include_context 'login admin'

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { true }
          include_examples 'status code', 200
        end

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { false }
          include_examples 'status code', 401
        end
      end
    end

    describe '#create' do
      subject(:request) { post apps_url, params: { app: app_attributes } }
      let(:app_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:app)
      end

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 401
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 401
      end

      context 'role: admin' do
        let(:admin) { FactoryBot.create(:admin, flag_stamps: flag_stamps) }
        include_context 'login admin'

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { true }
          include_examples 'status code', 302
        end

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { false }
          include_examples 'status code', 401
        end
      end
    end

    describe '#show' do
      subject(:request) { get app_path(some_app) }

      # IMPORTANT: 'app' as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 401
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 401
      end

      context 'role: admin' do
        let(:admin) { FactoryBot.create(:admin, flag_stamps: flag_stamps) }
        include_context 'login admin'

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { true }
          include_examples 'status code', 200
        end

        context 'admin has set #flag_stamps to true' do
          let(:flag_stamps) { false }
          include_examples 'status code', 401
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
