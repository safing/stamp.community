RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:user)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:role).in_array(%w[user moderator admin]) }
  end

  describe 'relations' do
    it { is_expected.to have_one(:api_key) }
    it { is_expected.to have_many(:domains).with_foreign_key(:creator_id) }
    it { is_expected.to have_many(:stamps).with_foreign_key(:creator_id) }
    it { is_expected.to have_many(:votes) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:confirmation_token).unique }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
    it { is_expected.to have_db_index(:unlock_token).unique }
  end

  describe '#create' do
    subject { user.save }
    let(:user) { FactoryBot.build(:user, reputation: reputation) }

    before { allow_required_integer_env('USER_INITIAL_REPUTATION').and_return(0) }

    context 'reputation is nil' do
      let(:reputation) { nil }

      it 'calls #add_reputation' do
        expect(user).to receive(:add_reputation).and_call_original
        subject
      end

      it 'sets reputation USER_INITIAL_REPUTATION' do
        subject
        expect(user.reputation).to eq(0)
      end
    end

    context 'reputation is set' do
      let(:reputation) { 20 }

      it 'calls #add_reputation' do
        expect(user).to receive(:add_reputation).and_call_original
        subject
      end

      it 'does not overwrite the set reputation' do
        subject
        expect(user.reputation).to eq(20)
      end
    end
  end

  describe '#voting_power' do
    subject { user.voting_power }
    let(:user) { FactoryBot.create(:user, reputation: reputation) }

    context 'user has negative REP' do
      let(:reputation) { -100 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has 0 REP' do
      let(:reputation) { 0 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has positive REP' do
      context 'user has between 1..9 REP' do
        let(:reputation) { Faker::Number.between(1, 9) }

        it 'returns 1' do
          expect(subject).to eq(1)
        end
      end

      context 'user has between 10..99 REP' do
        let(:reputation) { Faker::Number.between(10, 99) }

        it 'returns 2' do
          expect(subject).to eq(2)
        end
      end

      context 'user has between 100..999 REP' do
        let(:reputation) { Faker::Number.between(100, 999) }

        it 'returns 3' do
          expect(subject).to eq(3)
        end
      end

      context 'user has between 1000..9999 REP' do
        let(:reputation) { Faker::Number.between(1000, 9999) }

        it 'returns 4' do
          expect(subject).to eq(4)
        end
      end
    end
  end

  describe '#can_vote?(votable)' do
    subject { user.can_vote?(votable) }

    let(:user) { FactoryBot.create(:user) }
    let(:votable) { FactoryBot.create(:stamp) }

    before { allow_required_integer_env('USER_DAILY_VOTING_LIMIT').and_return(3) }

    context 'user already voted on votable' do
      before { FactoryBot.create(:vote, user: user, votable: votable) }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'user reached daily vote limit' do
      before { FactoryBot.create_list(:vote, 3, user: user) }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    it 'returns true' do
      expect(subject).to be true
    end
  end

  describe 'roles' do
    describe '#moderator?' do
      subject { user.moderator? }

      context 'user is a normal user' do
        let(:user) { FactoryBot.create(:user) }

        it { is_expected.to be false }
      end

      context 'user is a moderator' do
        let(:user) { FactoryBot.create(:moderator) }

        it { is_expected.to be true }
      end

      context 'user is an admin' do
        let(:user) { FactoryBot.create(:admin) }

        it { is_expected.to be true }
      end
    end

    describe '#admin?' do
      subject { user.admin? }

      context 'user is a normal user' do
        let(:user) { FactoryBot.create(:user) }

        it { is_expected.to be false }
      end

      context 'user is a moderator' do
        let(:user) { FactoryBot.create(:moderator) }

        it { is_expected.to be false }
      end

      context 'user is an admin' do
        let(:user) { FactoryBot.create(:admin) }

        it { is_expected.to be true }
      end
    end
  end
end
