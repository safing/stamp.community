RSpec.describe ApiKey, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:user).required(true) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:token).unique(true) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
