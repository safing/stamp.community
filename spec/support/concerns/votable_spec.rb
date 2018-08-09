RSpec.shared_examples 'a votable model' do |options|
  let(:instance) { FactoryBot.create(options[:model]) }

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
    subject { instance }

    let(:instance) { FactoryBot.create(:stamp, state: state) }
    let(:state) { :in_progress }

    describe 'transitions' do
      it ':in_progress => :accepted' do
        is_expected.to transition_from(
          :in_progress,
          to_state: :accepted,
          on_event: :accept
        )
      end

      it ':in_progress => :denied' do
        is_expected.to transition_from(
          :in_progress,
          to_state: :denied,
          on_event: :deny
        )
      end

      it ':accepted => :archive' do
        is_expected.to transition_from(
          :accepted,
          to_state: :archived,
          on_event: :archive
        )
      end
    end

    describe '#accept!' do
      subject { instance.accept! }
      let(:state) { :in_progress }

      context 'domain already has an accepted sibling' do
        it 'calls archive_accepted_siblings!' do
          expect(instance).to receive(:archive_accepted_siblings!).and_return(true)
          subject
        end
      end
    end

    describe '#archive!' do
      subject { instance.archive! }
      let(:state) { :accepted }
    end

    describe '#overrule!' do
      subject { instance.overrule! }
      let(:state) { :accepted }
    end

    describe '#archive_accepted_siblings!' do
      subject { instance.archive_accepted_siblings! }
      let!(:accepted_sibling) do
        FactoryBot.create(:stamp, :accepted, stampable: instance.domain, label: instance.label)
      end

      it 'archives the accepted sibling' do
        expect { subject }.to change {
          accepted_sibling.reload.state
        }.from('accepted').to('archived')
      end
    end
  end
end
