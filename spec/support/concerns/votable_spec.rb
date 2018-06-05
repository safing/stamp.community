# rubocop:disable Metrics/BlockLength
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
    subject { instance }

    let(:instance) { FactoryBot.create(:stamp, state: state) }
    let(:state) { :in_progress }

    describe 'transitions' do
      it { is_expected.to transition_from :in_progress, to_state: :accepted, on_event: :accept }
      it { is_expected.to transition_from :in_progress, to_state: :denied, on_event: :deny }
      it { is_expected.to transition_from :accepted, to_state: :archived, on_event: :archive }
      it do
        is_expected.to transition_from :accepted, :denied, to_state: :overruled, on_event: :overrule
      end
    end

    describe '#accept!' do
      subject { instance.accept! }
      let(:state) { :in_progress }

      it 'rewards the creator' do
        expect(instance).to receive(:award_creator!).and_return(true)
        subject
      end

      it 'rewards all upvoters' do
        expect(instance).to receive(:award_upvoters!).and_return(true)
        subject
      end

      it 'punishes all downvoters' do
        expect(instance).to receive(:punish_downvoters!).and_return(true)
        subject
      end

      context 'domain already has a instance for that label' do
        it 'archives the old instance'
      end
    end

    describe '#deny!' do
      subject { instance.deny! }
      let(:state) { :in_progress }

      it 'punishes the creator' do
        expect(instance).to receive(:punish_creator!).and_return(true)
        subject
      end

      it 'punishes all upvoters' do
        expect(instance).to receive(:punish_upvoters!).and_return(true)
        subject
      end

      it 'rewards all downvoters' do
        expect(instance).to receive(:award_downvoters!).and_return(true)
        subject
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
  end

  describe 'Votable::RewardSystem' do
    let(:instance) { FactoryBot.create(options[:model]) }

    describe '#award_creator!' do
      subject { instance.award_creator! }

      before { expect_required_integer_env('STAMP_CREATOR_PRIZE').and_return(5) }

      it 'increases the creators reputation by 5' do
        expect { subject }.to change { instance.creator.reputation }.by(5)
      end
    end

    describe '#punish_creator!' do
      subject { instance.punish_creator! }

      before { expect_required_integer_env('STAMP_CREATOR_PENALTY').and_return(-10) }

      it 'decreases the creators reputation by 10' do
        expect { subject }.to change { instance.creator.reputation }.by(-10)
      end
    end

    describe '#award_upvoters!' do
      subject { instance.award_upvoters! }
      let(:instance) { FactoryBot.create(options[:model], :with_upvotes) }
      let(:vote_1) { instance.upvotes.first }
      let(:vote_2) { instance.upvotes.second }

      before { expect_required_integer_env('STAMP_UPVOTER_PRIZE').and_return(1) }

      it 'increases all accept voters reputation by 1' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(1).and \
          change { vote_2.reload.user.reputation }.by(1)
      end
    end

    describe '#punish_upvoters!' do
      subject { instance.punish_upvoters! }
      let(:instance) { FactoryBot.create(options[:model], :with_upvotes) }
      let(:vote_1) { instance.upvotes.first }
      let(:vote_2) { instance.upvotes.second }

      before { expect_required_integer_env('STAMP_UPVOTER_PENALTY').and_return(-5) }

      it 'decreases all accept voters reputation by -5' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(-5).and \
          change { vote_2.reload.user.reputation }.by(-5)
      end
    end

    describe '#award_downvoters!' do
      subject { instance.award_downvoters! }
      let(:instance) { FactoryBot.create(options[:model], :with_downvotes) }
      let(:vote_1) { instance.downvotes.first }
      let(:vote_2) { instance.downvotes.second }

      before { expect_required_integer_env('STAMP_DOWNVOTER_PRIZE').and_return(1) }

      it 'increases all accept voters reputation by 1' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(1).and \
          change { vote_2.reload.user.reputation }.by(1)
      end
    end

    describe '#punish_downvoters!' do
      subject { instance.punish_downvoters! }
      let(:instance) { FactoryBot.create(options[:model], :with_downvotes) }
      let(:vote_1) { instance.downvotes.first }
      let(:vote_2) { instance.downvotes.second }

      before { expect_required_integer_env('STAMP_DOWNVOTER_PENALTY').and_return(-5) }

      it 'decreases all accept voters reputation by -5' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(-5).and \
          change { vote_2.reload.user.reputation }.by(-5)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
