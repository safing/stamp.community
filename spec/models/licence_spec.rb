RSpec.describe Licence, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:licence)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to have_many(:labels) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
