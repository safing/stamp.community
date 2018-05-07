RSpec.describe Vote, type: :model do
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
