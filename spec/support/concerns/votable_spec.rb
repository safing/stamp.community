RSpec.shared_examples 'a votable model' do |options|
  describe 'relations' do
    it { is_expected.to have_many(:votes) }
    it { is_expected.to belong_to(:creator).class_name('User').required(true) }
    it { is_expected.to belong_to(:stampable).required(true) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:creator_id) }
    it { is_expected.to have_db_index(%i[stampable_type stampable_id]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:state) }
  end

  describe 'state machine' do
    subject { FactoryBot.create(options[:model]) }

    describe 'transitions' do
      it { is_expected.to transition_from :in_progress, to_state: :accepted, on_event: :accept }
      it { is_expected.to transition_from :in_progress, to_state: :denied, on_event: :deny }
      it { is_expected.to transition_from :accepted, to_state: :archived, on_event: :archive }
      it do
        is_expected.to transition_from :accepted, :denied, to_state: :overruled, on_event: :overrule
      end
    end
  end
end
