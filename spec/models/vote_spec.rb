RSpec.describe Vote, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:vote)).to be_valid
  end

  describe 'relations' do
    subject { FactoryBot.create(:vote) }

    it { is_expected.to belong_to(:user).required(true) }
    it { is_expected.to belong_to(:votable).required(true) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:vote) }

    it { is_expected.to validate_presence_of(:power) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:votable) }

    describe 'vote creation validation' do
      # assure that voted object is in_progress
      context 'stamp is accepted' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is denied' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is disputed' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is archived' do
        it 'denies user to vote'
        it 'denies user to comment'
      end
    end
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[votable_type votable_id]) }
  end

  describe '#create' do
    subject { vote.save }
    let(:vote) { FactoryBot.build(:vote) }

    it 'calls #cache_users_voting_power' do
      expect(vote).to receive(:cache_users_voting_power)
      subject
    end

    it 'creates a vote' do
      expect { subject }.to change { Vote.count }.from(0).to(1)
    end
  end

  describe '#save' do
    subject { vote.save }

    context 'vote is not a new record' do
      let(:vote) { FactoryBot.create(:vote) }

      it 'does not call #cache_users_voting_power' do
        expect(vote).not_to receive(:cache_users_voting_power)
        subject
      end
    end
  end

  describe '.joins_activities' do
    subject { Vote.joins_activities }

    before do
      FactoryBot.create(:flag_stamp, :with_votes, activities: true)

      # create noise
      FactoryBot.create_list(:transition_activity, 2)
      FactoryBot.create_list(:vote, 2)
    end

    it 'returns all votes with their adjoining activities' do
      expect(subject.count).to eq(4)

      # cannot select two 'id' columns
      selection = subject.select('
        votes.*,
        activities.owner_id,
        activities.owner_type,
        activities.recipient_id,
        activities.recipient_type,
        activities.trackable_id,
        activities.trackable_type
      ')

      # tests if the join is set up properly
      selection.each do |vote|
        expect(vote.id).to eq(vote.trackable_id)
        expect('Vote').to eq(vote.trackable_type)
        expect(vote.user_id).to eq(vote.owner_id)
        expect('User').to eq(vote.owner_type)
        expect(vote.votable_id).to eq(vote.recipient_id)
        expect(vote.votable_type).to eq(vote.recipient_type)
      end
    end
  end

  describe '#cache_users_voting_power' do
    subject { vote.send('cache_users_voting_power') }
    let(:vote) { FactoryBot.build(:vote, power: nil) }

    it 'saves the users voting power as vote#power' do
      expect { subject }.to change { vote.power }.from(nil).to(vote.user.voting_power)
    end
  end
end
