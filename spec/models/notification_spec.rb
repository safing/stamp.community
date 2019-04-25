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
    it { is_expected.to validate_presence_of(:activity) }
    it { is_expected.to validate_presence_of(:actor) }
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:reference) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:activity_id) }
    it { is_expected.to have_db_index(:actor_id) }
    it { is_expected.to have_db_index(:recipient_id) }
    it { is_expected.to have_db_index([:reference_type, :reference_id]) }
  end

  describe '#create' do
    subject { notification.save }
    let(:notification) { FactoryBot.build(:notification) }

    it 'queues a NotificationBroadcastWorker' do
      expect { subject }.to change { NotificationBroadcastWorker.jobs.size }.by(1)
    end
  end

  describe '#actor' do
    subject { notification.actor }

    context 'actor_id is -1' do
        let(:notification) { FactoryBot.create(:notification, :system_actor) }

      it 'returns the System object' do
        expect(subject).to eq(System.new)
      end
    end

    context 'actor_id is a normal id' do
      let(:notification) { FactoryBot.create(:notification, actor: user) }
      let(:user) { FactoryBot.create(:user) }

      it 'retrieves the user with the id' do
        expect(subject).to eq(user)
      end
    end
  end
end
