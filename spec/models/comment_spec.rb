RSpec.describe Comment, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:comment)).to be_valid
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[commentable_type commentable_id]) }
  end

  describe 'relations' do
    subject { FactoryBot.create(:comment) }

    it { is_expected.to belong_to(:user).required(true) }
    it { is_expected.to belong_to(:commentable).required(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:content).is_at_least(40) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:commentable) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe '#create_activity(*args)' do
    include_context 'with activity tracking'

    subject { comment.create_activity(*params) }

    let(:comment) { FactoryBot.create(:initial_comment) }
    let(:stamp) { Stamp.find(comment.commentable_id) }
    let(:params) { [:create, owner: actor, recipient: stamp] }
    let(:actor) { comment.user }

    it 'creates an activity' do
      expect { subject }.to change { PublicActivity::Activity.count }.by(1)
    end

    it 'returns the created activity' do
      expect(subject).to be_a(PublicActivity::Activity)
    end

    context 'noone else has commented on the commentable' do
      it 'does not create any notifications' do
        expect { subject }.not_to change { Notification.count }
      end
    end

    context 'others have commented on the commentable' do
      before do
        other_commenters.each do |commenter|
          stamp.comments << FactoryBot.create(:comment, user: commenter)
        end
        stamp.save
      end

      let(:other_commenters) { FactoryBot.create_list(:user, 2) }

      it 'notifies all peers (by creating a notification)' do
        expect { subject }.to change { Notification.count }.by(2)
      end

      it 'creates notifications {activity: self, actor: actor, recipient: other commenters, reference: stamp}' do
        subject

        activity = PublicActivity::Activity.last
        other_commenters.each do |commenter|
          notification = Notification.find_by(recipient_id: commenter.id)
          expect(notification.activity).to eq(activity)
          expect(notification.actor).to eq(actor)
          expect(notification.recipient_id).to eq(commenter.id)
          expect(notification.reference).to eq(stamp)
        end
      end
    end
  end
end
