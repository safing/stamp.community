RSpec.describe ApiKey, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:user).required(true) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:token).unique(true) }
    it { is_expected.to have_db_index(:user_id) }
  end
end
