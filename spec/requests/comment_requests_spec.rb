RSpec.feature 'stamp requests', type: :request do
  describe 'authourization' do
    describe '#create' do
      subject(:request) { post stamp_comments_url(stamp.id), params: comment_attributes }
      let(:stamp) { FactoryBot.create(:stamp, state: state) }
      let(:state) { :in_progress }
      let(:comment_attributes) { { comment: { content: '1' * 40 } } }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'

        context 'state is :in_progress' do
          let(:state) { :in_progress }
          include_examples 'status code', 302
        end

        context 'state is :accepted' do
          let(:state) { :accepted }
          include_examples 'status code', 401
        end

        context 'state is :archived' do
          let(:state) { :archived }
          include_examples 'status code', 401
        end

        context 'state is :denied' do
          let(:state) { :denied }
          include_examples 'status code', 401
        end

        context 'state is :disputed' do
          let(:state) { :disputed }
          include_examples 'status code', 401
        end
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
