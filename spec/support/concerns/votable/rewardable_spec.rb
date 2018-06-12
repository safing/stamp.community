# rubocop:disable Metrics/BlockLength
RSpec.shared_examples 'a rewardable model' do |options|
  let(:instance) { FactoryBot.create(options[:model]) }
  let(:class_name_env) { instance.class_name_env }

  describe 'state machine' do
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

    describe '#award_creator!' do
      subject { instance.award_creator! }

      before { expect_required_integer_env("#{class_name_env}_CREATOR_PRIZE").and_return(5) }

      it 'increases the creators reputation by 5' do
        expect { subject }.to change { instance.creator.reputation }.by(5)
      end
    end

    describe '#punish_creator!' do
      subject { instance.punish_creator! }

      before { expect_required_integer_env("#{class_name_env}_CREATOR_PENALTY").and_return(-10) }

      it 'decreases the creators reputation by 10' do
        expect { subject }.to change { instance.creator.reputation }.by(-10)
      end
    end

    describe '#award_upvoters!' do
      subject { instance.award_upvoters! }
      let(:instance) { FactoryBot.create(options[:model], :with_upvotes) }
      let(:vote_1) { instance.upvotes.first }
      let(:vote_2) { instance.upvotes.second }

      before { expect_required_integer_env("#{class_name_env}_UPVOTER_PRIZE").and_return(1) }

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

      before { expect_required_integer_env("#{class_name_env}_UPVOTER_PENALTY").and_return(-5) }

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

      before { expect_required_integer_env("#{class_name_env}_DOWNVOTER_PRIZE").and_return(1) }

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

      before { expect_required_integer_env("#{class_name_env}_DOWNVOTER_PENALTY").and_return(-5) }

      it 'decreases all accept voters reputation by -5' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(-5).and \
          change { vote_2.reload.user.reputation }.by(-5)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
