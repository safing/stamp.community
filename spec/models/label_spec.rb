RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:parent).class_name('Label').optional }
  end
end
