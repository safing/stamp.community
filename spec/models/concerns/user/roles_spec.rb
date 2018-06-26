RSpec.describe User, type: :model do
  describe '::Roles' do
    describe 'validations' do
      it { is_expected.to validate_inclusion_of(:role).in_array(User::Roles::ROLES) }
    end

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
