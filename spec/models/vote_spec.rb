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

  describe '#cache_users_voting_power' do
    subject { vote.send('cache_users_voting_power') }
    let(:vote) { FactoryBot.build(:vote) }

    it 'saves the users voting power as vote#power' do
      expect { subject }.to change { vote.power }.from(nil).to(vote.user.voting_power)
    end
  end
end
