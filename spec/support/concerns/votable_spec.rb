RSpec.shared_examples 'a votable model' do |options|
  let(:instance) { FactoryBot.create(options[:model]) }

  describe 'relations' do
    it { is_expected.to have_many(:votes) }
    it { is_expected.to belong_to(:creator).class_name('User').required(true) }
    it { is_expected.to belong_to(:stampable).required(true) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
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

    describe '#concludable?' do
      subject { instance.concludable? }

      before do
        allow_required_integer_env('VOTABLE_POWER_THRESHOLD').and_return(10)
        allow_required_integer_env('VOTABLE_MAJORITY_THRESHOLD').and_return(75)
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
          let(:majority_size) { 75 }

          it 'returns true' do
            expect(subject).to be true
          end
        end

        context 'majority_size is above majority_threshold' do
          let(:majority_size) { 80 }

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
          let(:majority_size) { 75 }

          it 'returns true' do
            expect(subject).to be true
          end
        end

        context 'majority_size is above majority_threshold' do
          let(:majority_size) { 80 }

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
  end
end
