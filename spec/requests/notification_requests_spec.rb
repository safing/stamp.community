RSpec.feature 'notification requests', type: :request do
  describe 'authentication' do
    describe '#read_all' do
      subject(:request) { post read_all_notifications_url, xhr: true }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'
        include_examples 'status code', 200
      end
    end
  end

  describe '#read_all' do
    subject(:request) { post read_all_notifications_url, xhr: true }
    let(:user) { FactoryBot.create(:user, :with_notifications) }

    include_context 'login user'

    it 'marks all unread notifications of the user as read' do
      expect { subject }.to change { user.notifications.unread.count }.from(2).to(0)
    end
  end
end
