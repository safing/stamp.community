RSpec.describe NotificationBroadcastWorker, type: :worker do
  describe '#perform' do
    subject { worker.perform(notification.id) }

    let(:worker) { NotificationBroadcastWorker.new }
    let(:notification) { FactoryBot.create(:notification) }

    it 'calls NotificationsChannel.broadcast_to' do
      expect(NotificationsChannel).to receive(:broadcast_to)
      subject
    end
  end
end
