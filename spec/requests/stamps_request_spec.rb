RSpec.describe 'stamp request', type: :request do
  describe 'show' do
    subject(:request) { get stamp_url(stamp.id) }

    let(:stamp) { FactoryBot.create(:stamp) }

    describe 'authourization' do
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
