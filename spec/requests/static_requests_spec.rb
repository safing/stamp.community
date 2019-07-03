RSpec.feature 'static requests', type: :request do
  describe 'authentication' do
    describe '#terms' do
      subject(:request) { get tos_path }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 200
      end

      context 'user is authenticated' do
        include_context 'login user'
        include_examples 'status code', 200
      end
    end
  end
end
