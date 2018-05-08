RSpec.shared_examples 'a votable model' do
  describe 'relations' do
    it { is_expected.to have_many(:votes) }
    it { is_expected.to belong_to(:creator).class_name('User').required(true) }
    it { is_expected.to belong_to(:stampable).required(true) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:creator_id) }
    it { is_expected.to have_db_index(%i[stampable_type stampable_id]) }
  end
end
