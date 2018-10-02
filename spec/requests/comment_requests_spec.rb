RSpec.feature 'stamp requests', type: :request do
  describe 'authourization' do
    describe '#create' do
      subject(:request) { post stamp_comments_url(stamp.id), params: comment_attributes }
      let(:stamp) { FactoryBot.create(:stamp) }
      let(:comment_attributes) { { comment: { content: '1' * 40 } } }

      context 'role: guest' do
        include_examples 'status code', 401
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
  end
end
