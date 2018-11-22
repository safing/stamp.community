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
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
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
        include_examples 'status code', 302
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 302
      end
    end

    describe '#show' do
      subject(:request) { get app_path(some_app) }

      # app as a variable name will remove all path helpers
      let(:some_app) { FactoryBot.create(:app) }

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
end
