RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:licence) }
    it { is_expected.to belong_to(:parent).class_name('Label').optional }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:licence_id) }
    it { is_expected.to have_db_index(:parent_id) }
  end
end
