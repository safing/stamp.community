RSpec.shared_examples 'a votable model' do |options|
  let(:instance) { FactoryBot.create(options[:factory]) }

  describe 'relations' do
    it { is_expected.to have_many(:votes) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[stampable_type stampable_id]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:state) }
  end

  describe 'fields' do
    it { is_expected.to have_attr_accessor(:transition_activity) }
  end

  describe 'state machine' do
    subject { instance }

    let(:instance) { FactoryBot.create(options[:factory], state: state) }
    let(:state) { :in_progress }

    include_context 'with activity tracking'

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

      it ':in_progress => :disputed' do
        is_expected.to transition_from(
          :in_progress,
          to_state: :disputed,
          on_event: :dispute
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
      include_examples 'set threshold metrics of transition'

      context 'stampable already has an accepted sibling' do
        it 'calls archive_accepted_siblings!' do
          expect(instance).to receive(:archive_accepted_siblings!).and_return(true)
          subject
        end
      end

      include_examples 'notify creator of transition', transition: :accept

      context 'with votes' do
        let(:instance) do
          FactoryBot.create(options[:factory], :with_votes, state: state, activities: true)
        end

        include_examples 'notify voters of transition', transition: :accept
      end

      it 'saves the threshold metrics in the transition activity' do
        subject
        activity = instance.transition_activity
        expect(activity.parameters['majority_threshold']).to eq(80)
        expect(activity.parameters['power_threshold']).to eq(5)
      end
    end

    describe '#deny!' do
      subject { instance.deny! }
      let(:state) { :in_progress }
      include_examples 'set threshold metrics of transition'

      include_examples 'notify creator of transition', transition: :deny

      context 'with votes' do
        let(:instance) do
          FactoryBot.create(options[:factory], :with_votes, state: state, activities: true)
        end

        include_examples 'notify voters of transition', transition: :deny
      end

      it 'saves the threshold metrics in the transition activity' do
        subject
        activity = instance.transition_activity
        expect(activity.parameters['majority_threshold']).to eq(80)
        expect(activity.parameters['power_threshold']).to eq(5)
      end
    end

    describe '#dispute!' do
      subject { instance.dispute! }
      let(:state) { :in_progress }
      include_examples 'set threshold metrics of transition'

      include_examples 'notify creator of transition', transition: :dispute

      context 'with votes' do
        let(:instance) do
          FactoryBot.create(options[:factory], :with_votes, state: state, activities: true)
        end

        include_examples 'notify voters of transition', transition: :dispute
      end

      it 'saves the threshold metrics in the transition activity' do
        subject
        activity = instance.transition_activity
        expect(activity.parameters['majority_threshold']).to eq(80)
        expect(activity.parameters['power_threshold']).to eq(5)
      end
    end

    describe '#archive!' do
      subject { instance.archive! }
      let(:state) { :accepted }

      include_examples 'notify creator of transition', transition: :archive

      context 'with votes' do
        let(:instance) do
          FactoryBot.create(options[:factory], :with_votes, state: state, activities: true)
        end

        include_examples 'do not notify voters of transition', transition: :archive
      end

      it 'have not parameters' do
        subject
        activity = instance.transition_activity
        expect(activity.parameters).to eq({})
      end
    end

    describe '#archive_accepted_siblings!' do
      subject { instance.archive_accepted_siblings! }

      before do
        allow(instance).to receive_message_chain(:siblings, :accepted)
          .and_return([accepted_sibling])
      end

      let!(:accepted_sibling) do
        FactoryBot.create(options[:factory], :accepted, stampable: instance.stampable)
      end

      it 'archives the accepted sibling' do
        # needed for the notification
        PublicActivity.with_tracking do
          expect { subject }.to change {
            accepted_sibling.reload.state
          }.from('accepted').to('archived')
        end
      end
    end
  end

  describe '#concludable?' do
    subject { instance.concludable? }

    before do
      allow(instance).to receive(:total_power).and_return(total_power)
      allow(instance).to receive(:majority_size).and_return(majority_size)
    end

    context 'total_power is below power_threshold' do
      let(:total_power) { 9 }

      context 'majority_size is below majority_threshold' do
        let(:majority_size) { 74 }

        it 'returns false' do
          expect(subject).to be false
        end
      end

      context 'majority_size equals majority_threshold' do
        let(:majority_size) { 75 }

        it 'returns false' do
          expect(subject).to be false
        end
      end

      context 'majority_size is above majority_threshold' do
        let(:majority_size) { 80 }

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end

    context 'total_power equals power_threshold' do
      let(:total_power) { 10 }

      context 'majority_size is below majority_threshold' do
        let(:majority_size) { 74 }

        it 'returns false' do
          expect(subject).to be false
        end
      end

      context 'majority_size equals majority_threshold' do
        let(:majority_size) { 100 }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'majority_size is above majority_threshold' do
        let(:majority_size) { 100 }

        it 'returns true' do
          expect(subject).to be true
        end
      end
    end

    context 'total_power is above power power_threshold' do
      let(:total_power) { 20 }

      context 'majority_size is below majority_threshold' do
        let(:majority_size) { 74 }

        it 'returns false' do
          expect(subject).to be false
        end
      end

      context 'majority_size equals majority_threshold' do
        let(:majority_size) { 100 }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'majority_size is above majority_threshold' do
        let(:majority_size) { 100 }

        it 'returns true' do
          expect(subject).to be true
        end
      end
    end
  end

  describe '#majority_size' do
    subject { instance.majority_size }

    before do
      allow(instance).to receive(:upvote_power).and_return(upvote_power)
      allow(instance).to receive(:downvote_power).and_return(downvote_power)
    end

    context 'upvoters have majority' do
      let(:upvote_power) { 140 }
      let(:downvote_power) { 60 }

      it 'returns 70' do
        expect(subject).to eq(70)
      end
    end

    context 'downvoters have majority' do
      let(:upvote_power) { 40 }
      let(:downvote_power) { 60 }

      it 'returns 60' do
        expect(subject).to eq(60)
      end
    end

    context 'votes are even' do
      let(:upvote_power) { 40 }
      let(:downvote_power) { 40 }

      it 'returns 50' do
        expect(subject).to eq(50)
      end
    end
  end

  describe '#majority_type' do
    subject { instance.majority_type }

    before do
      allow(instance).to receive(:upvote_power).and_return(upvote_power)
      allow(instance).to receive(:downvote_power).and_return(downvote_power)
    end

    context 'upvoters have majority' do
      let(:upvote_power) { 70 }
      let(:downvote_power) { 30 }

      it 'returns :upvoters' do
        expect(subject).to eq(:upvoters)
      end
    end

    context 'downvoters have majority' do
      let(:upvote_power) { 10 }
      let(:downvote_power) { 90 }

      it 'returns :downvoters' do
        expect(subject).to eq(:downvoters)
      end
    end

    context 'votes are even' do
      let(:upvote_power) { 50 }
      let(:downvote_power) { 50 }

      it 'returns :even' do
        expect(subject).to eq(:even)
      end
    end
  end

  describe '#conclude!' do
    subject { instance.conclude! }

    context 'votable is not concludable' do
      before { allow(instance).to receive(:concludable?).and_return(false) }

      it 'calls Votable::DisputeWorker' do
        expect(Votable::DisputeWorker).to receive(:perform_async).with(
          instance.class.to_s,
          instance.id
        )
        subject
      end
    end

    context 'votable is concludable' do
      before { allow(instance).to receive(:concludable?).and_return(true) }

      context 'majority of voters are :upvoters' do
        before { allow(instance).to receive(:majority_type).and_return(:upvoters) }

        it 'calls Votable::AcceptWorker' do
          expect(Votable::AcceptWorker).to receive(:perform_async).with(
            instance.class.to_s,
            instance.id
          )
          subject
        end
      end

      context 'majority of voters are :downvoters' do
        before { allow(instance).to receive(:majority_type).and_return(:downvoters) }

        it 'calls Votable::DenyWorker' do
          expect(Votable::DenyWorker).to receive(:perform_async).with(
            instance.class.to_s,
            instance.id
          )
          subject
        end
      end
    end
  end

  describe '#conclusion_activity' do
    subject { instance.conclusion_activity }

    context 'state is in_progress' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'state is accepted' do
      before do
        PublicActivity.with_tracking do
          instance.accept!
        end
      end

      it 'returns the stamps conclusion_activity with key: stamp.accept' do
        expect(subject).to be_kind_of(PublicActivity::Activity)
        expect(subject.trackable).to eq(instance)
        expect(subject.key).to eq('stamp.accept')
      end
    end

    context 'state is denied' do
      before do
        PublicActivity.with_tracking do
          instance.deny!
        end
      end

      it 'returns the stamps conclusion_activity with key: stamp.deny' do
        expect(subject).to be_kind_of(PublicActivity::Activity)
        expect(subject.trackable).to eq(instance)
        expect(subject.key).to eq('stamp.deny')
      end
    end

    context 'state is disputed' do
      before do
        PublicActivity.with_tracking do
          instance.dispute!
        end
      end

      it 'returns the stamps conclusion_activity with key: stamp.dispute' do
        expect(subject).to be_kind_of(PublicActivity::Activity)
        expect(subject.trackable).to eq(instance)
        expect(subject.key).to eq('stamp.dispute')
      end
    end

    context 'state is archived' do
      before do
        PublicActivity.with_tracking do
          instance.accept!
          instance.archive!
        end
      end

      it 'returns the stamps conclusion_activity with key: stamp.accept' do
        expect(subject).to be_kind_of(PublicActivity::Activity)
        expect(subject.trackable).to eq(instance)
        expect(subject.key).to eq('stamp.accept')
      end
    end
  end

  describe 'activities' do
    subject { instance }

    let(:instance) { FactoryBot.create(options[:factory], state: state) }
    let(:state) { :in_progress }

    describe '#accept!' do
      subject { instance.accept! }
      let(:state) { :in_progress }

      it "creates an 'stamp.accept' activity with {owner_type: System, owner_id: -1}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq("#{instance.param_key}.accept")
          expect(activity.owner_type).to eq('System')
          expect(activity.owner_id).to eq(-1)
          expect(activity.trackable).to eq(instance)
          expect(activity.recipient).to eq(instance.stampable)
        end
      end
    end

    describe '#deny!' do
      subject { instance.deny! }
      let(:state) { :in_progress }

      it "creates an 'stamp.deny' activity with {owner_type: System, owner_id: -1}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq("#{instance.param_key}.deny")
          expect(activity.owner_type).to eq('System')
          expect(activity.owner_id).to eq(-1)
          expect(activity.trackable).to eq(instance)
          expect(activity.recipient).to eq(instance.stampable)
        end
      end
    end

    describe '#dispute!' do
      subject { instance.dispute! }
      let(:state) { :in_progress }

      it "creates an 'stamp.dispute' activity with {owner_type: System, owner_id: -1}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq("#{instance.param_key}.dispute")
          expect(activity.owner_type).to eq('System')
          expect(activity.owner_id).to eq(-1)
          expect(activity.trackable).to eq(instance)
          expect(activity.recipient).to eq(instance.stampable)
        end
      end
    end

    describe '#archive!' do
      subject { instance.archive! }
      let(:state) { :accepted }

      it "creates an 'stamp.archive' activity with {owner_type: System, owner_id: -1}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq("#{instance.param_key}.archive")
          expect(activity.owner_type).to eq('System')
          expect(activity.owner_id).to eq(-1)
          expect(activity.trackable).to eq(instance)
          expect(activity.recipient).to eq(instance.stampable)
        end
      end
    end
  end
end
