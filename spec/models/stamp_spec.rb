RSpec.describe Stamp, type: :model do
  it_behaves_like 'a votable model'

  it 'has a valid factory' do
    expect(FactoryBot.create(:stamp)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:label).required(true) }
  end

  describe 'validations' do
    it do
      is_expected.to validate_numericality_of(:percentage)
        .is_greater_than(0)
        .is_less_than_or_equal_to(100)
    end
    it { is_expected.to validate_presence_of(:percentage) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:label_id) }
  end

  describe '#domain?' do
    subject { stamp.domain? }
    let(:stamp) { FactoryBot.create(:stamp) }

    context 'stampable_type is domain' do
      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'stampable_type is not domain' do
      # TODO: implement when adding another stampable model
      # it 'returns false' do
      #   expect(subject).to be false
      # end
    end
  end
end
