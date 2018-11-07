RSpec.shared_examples 'a STI child of Stamp' do |options|
  it_behaves_like 'a votable model', factory: options[:factory]
  it_behaves_like 'a rewardable model', factory: options[:factory]

  subject { stamp }
  let(:stamp) { FactoryBot.create(options[:factory]) }

  describe 'relations' do
    it { is_expected.to have_many(:comments) }
    it { is_expected.to belong_to(:creator).class_name('User').required(true) }
    it { is_expected.to belong_to(:stampable).required(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:comments) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_inclusion_of(:type).in_array(%w[Stamp::Flag Stamp::Label]) }
    it { is_expected.to validate_presence_of(:creator) }
    it { is_expected.to validate_presence_of(:stampable) }
    it { is_expected.to validate_presence_of(:state) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[stampable_type stampable_id]) }
  end

  describe '#siblings' do
    subject { stamp.siblings }
    let(:stamp) { FactoryBot.create(:label_stamp) }

    context 'stamp has no siblings' do
      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'stamp has sibling stamps' do
      before { stamp.domain.stamps << FactoryBot.create_list(:label_stamp, 2) }

      it 'returns all siblings' do
        expect(subject.count).to eq(2)
      end

      it 'does not return itself' do
        expect(subject.pluck(:id)).not_to include(stamp.id)
      end
    end
  end
end
