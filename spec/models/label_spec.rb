RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label)).to be_valid
  end

  describe 'database' do
    it { is_expected.to have_db_index(:licence_id) }
    it { is_expected.to have_db_index(:parent_id) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:licence) }
    it { is_expected.to belong_to(:parent).class_name('Label').optional }

    it { is_expected.to have_many(:children).class_name('Label').with_foreign_key(:parent_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:licence) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_inclusion_of(:steps).in_array([1, 5, 10]) }
  end
  
  describe 'fields' do
    let(:label) { Label.new }

    it '#binary is set by default, has getter and setter' do
      expect(label.binary).to be false
      label.binary = true
      expect(label.binary).to be true
    end

    it '#steps is set by default, has getter and setter' do
      expect(label.steps).to eq(5)
      label.steps = 10
      expect(label.steps).to eq(10)
    end
  end
end
