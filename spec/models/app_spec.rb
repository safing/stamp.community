RSpec.describe App, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:app)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    xit { is_expected.to have_many(:data_stamps) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content).is_at_least(40) }
  end
end
