RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:label)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:licence) }
    it { is_expected.to belong_to(:parent).class_name('Label').optional }

    it { is_expected.to have_many(:children).class_name('Label').with_foreign_key(:parent_id) }
    it { is_expected.to have_many(:stamps) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:licence_id) }
    it { is_expected.to have_db_index(:parent_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:licence) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#stamps_including_child_labels' do
    subject { label.stamps_including_child_labels }
    let(:label) { FactoryBot.create(:label, :with_stamps) }

    before { FactoryBot.create_list(:stamp, 2) }

    context 'label has no child labels' do
      it 'return all direct stamps' do
        expect(subject.count).to eq(2)
      end
    end

    context 'label has child labels' do
      before do
        FactoryBot.create_list(:label, 2, :with_stamps, parent_id: label.id)
      end

      it 'returns the labels stamps and the child labels stamps' do
        expect(subject.count).to eq(6)
      end

      it 'returns all of the labels stamps' do
        expect(subject.where(stamps: { label_id: label.id }).count).to eq(2)
      end

      it 'returns all of child labels stamps' do
        expect(subject.where.not(stamps: { label_id: label.id }).count).to eq(4)
      end
    end
  end
end
