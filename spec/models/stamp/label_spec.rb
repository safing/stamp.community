RSpec.describe Stamp::Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label_stamp)).to be_valid
  end

  describe 'relations' do
    # shoulda-matchers does not support jsonb relations
    xit { is_expected.to belong_to(:label).class_name('::Label') }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:stampable_type).in_array(['Domain']) }
    it { is_expected.to validate_presence_of(:label_id) }
    it { is_expected.to validate_presence_of(:percentage) }
  end
end
