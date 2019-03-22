RSpec.shared_examples 'notify creator of transition' do |params|
  it "notifies the creator of the :#{params[:transition]} transition" do
    expect { subject }.to change { instance.creator.notifications.reload.count }.by(1)

    notification = instance.creator.notifications.last
    expect(notification.recipient).to eq(instance.creator)
    expect(notification.actor_id).to eq(-1)
    expect(notification.read).to be false
    expect(notification.activity.key).to eq("stamp.#{params[:transition]}")
    expect(notification.reference).to eq(instance)
  end
end

RSpec.shared_examples 'notify voters of transition' do |params|
  it "notifies all voters of the :#{params[:transition]} transition" do
    subject

    instance.votes.each do |vote|
      user_notifications = vote.user.notifications
      expect(user_notifications.count).to eq(1)

      notification = user_notifications.last
      expect(notification.recipient).to eq(vote.user)
      expect(notification.actor_id).to eq(-1)
      expect(notification.read).to be false
      expect(notification.activity.key).to eq("stamp.#{params[:transition]}")
      expect(notification.reference).to eq(instance)
    end
  end
end

RSpec.shared_examples 'do not notify voters of transition' do |params|
  it "notifies all voters of the :#{params[:transition]} transition" do
    subject

    instance.votes.each do |vote|
      expect(vote.user.notifications.count).to eq(0)
    end
  end
end
