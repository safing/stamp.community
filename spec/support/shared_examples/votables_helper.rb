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

RSpec.shared_examples 'set threshold metrics of transition' do
  before do
    allow_required_integer_env('STAMP_CONCLUDE_IN_HOURS').and_return(100)
    allow_required_integer_env('VOTABLE_MAJORITY_THRESHOLD').and_return(80)
    allow_required_integer_env('VOTABLE_POWER_THRESHOLD').and_return(5)
    allow_required_integer_env('STAMP::LABEL_CREATOR_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::LABEL_CREATOR_PRIZE').and_return(100)
    allow_required_integer_env('STAMP::LABEL_UPVOTER_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::LABEL_UPVOTER_PRIZE').and_return(100)
    allow_required_integer_env('STAMP::LABEL_DOWNVOTER_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::LABEL_DOWNVOTER_PRIZE').and_return(100)
    allow_required_integer_env('STAMP::FLAG_CREATOR_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::FLAG_CREATOR_PRIZE').and_return(100)
    allow_required_integer_env('STAMP::FLAG_UPVOTER_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::FLAG_DOWNVOTER_PENALTY').and_return(100)
    allow_required_integer_env('STAMP::FLAG_UPVOTER_PRIZE').and_return(100)
    allow_required_integer_env('STAMP::FLAG_DOWNVOTER_PRIZE').and_return(100)
  end
end
