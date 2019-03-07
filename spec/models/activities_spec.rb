RSpec.describe PublicActivity::Activity, type: :model do
  describe 'relations' do
    it { is_expected.to have_one(:boost).with_foreign_key(:cause_id) }
    it { is_expected.to have_many(:boosts).with_foreign_key(:trigger_id) }
  end

  describe 'database' do
    it { is_expected.to have_db_index([:trackable_id, :trackable_type]) }
    it { is_expected.to have_db_index([:owner_id, :owner_type]) }
    it { is_expected.to have_db_index([:recipient_id, :recipient_type]) }
  end
end
