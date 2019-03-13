RSpec.describe Notification, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:notification)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:activity).class_name('PublicActivity::Activity') }
    it { is_expected.to belong_to(:actor).class_name('User') }
    it { is_expected.to belong_to(:recipient).class_name('User') }
    it { is_expected.to belong_to(:reference) }
  end

  describe 'validations' do
  end

  describe 'database' do
    it { is_expected.to have_db_index(:activity_id) }
    it { is_expected.to have_db_index(:actor_id) }
    it { is_expected.to have_db_index(:recipient_id) }
    it { is_expected.to have_db_index([:reference_type, :reference_id]) }
  end
end
