RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:licence) }
    it { is_expected.to belong_to(:parent).class_name('Label').optional }

    it { is_expected.to have_many(:children).class_name('Label').with_foreign_key(:parent_id) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:licence_id) }
    it { is_expected.to have_db_index(:parent_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:licence) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_inclusion_of(:steps).in_array([1, 5, 10]) }
  end
end
