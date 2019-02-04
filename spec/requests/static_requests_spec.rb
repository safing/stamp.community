RSpec.feature 'static requests', type: :request do
  describe 'authourization' do
    describe '#terms' do
      subject(:request) { get tos_path }

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
