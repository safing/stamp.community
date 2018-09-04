RSpec.describe Comment, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:comment)).to be_valid
  end

  describe 'relations' do
    subject { FactoryBot.create(:comment) }

    it { is_expected.to belong_to(:user).required(true) }
    it { is_expected.to belong_to(:commentable).required(true) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:comment) }

    it { is_expected.to validate_length_of(:content).is_at_least(40) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[commentable_type commentable_id]) }
  end
end
