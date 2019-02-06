RSpec.shared_examples 'a rewardable model' do |options|
  let(:instance) { FactoryBot.create(options[:factory]) }
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
  end

  describe 'reward & punishment methods' do
    let(:activity) { FactoryBot.create(:transition_activity, trackable: instance) }

    # mock the activity created by the stamps state transition => Votable::State
    before do
      allow_any_instance_of(instance.class).to receive(:transition_activity).and_return(activity)
    end

    describe '#award_creator!' do
      subject { instance.award_creator! }

      before { expect_required_integer_env("#{class_name_env}_CREATOR_PRIZE").and_return(5) }

      it 'increases the creators reputation by 5' do
        expect { subject }.to change { instance.creator.reload.reputation }.by(5)
      end

      it 'creates a user boost (rep +5) which references the transition activity' do
        expect { subject }.to change { instance.creator.boosts.count }.by(1)

        boost = instance.creator.boosts.last
        expect(boost.reputation).to eq(5)
        expect(boost.activity).to eq(activity)
      end
    end

    describe '#punish_creator!' do
      subject { instance.punish_creator! }

      before { expect_required_integer_env("#{class_name_env}_CREATOR_PENALTY").and_return(-10) }

      it 'decreases the creators reputation by 10' do
        expect { subject }.to change { instance.creator.reload.reputation }.by(-10)
      end

      it 'creates a user boost (rep -10) which references the transition_activity' do
        expect { subject }.to change { instance.creator.boosts.count }.by(1)

        boost = instance.creator.boosts.last
        expect(boost.reputation).to eq(-10)
        expect(boost.activity).to eq(activity)
      end
    end

    describe '#award_upvoters!' do
      subject { instance.award_upvoters! }

      let(:instance) { FactoryBot.create(options[:factory], :with_up_and_downvotes) }
      let(:vote_1) { instance.upvotes.first }
      let(:vote_2) { instance.upvotes.second }

      before { expect_required_integer_env("#{class_name_env}_UPVOTER_PRIZE").and_return(1) }

      it 'increases all accept voters reputation by 1' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(1).and \
          change { vote_2.reload.user.reputation }.by(1)
      end

      it 'creates boosts (rep +1) for each upvoter which reference the transition_activity' do
        expect { subject }.to change { vote_1.reload.user.boosts.count }.by(1).and \
          change { vote_2.reload.user.boosts.count }.by(1)

        boost_1 = vote_1.user.boosts.last
        expect(boost_1.reputation).to eq(1)
        expect(boost_1.activity).to eq(activity)

        boost_2 = vote_2.user.boosts.last
        expect(boost_2.reputation).to eq(1)
        expect(boost_2.activity).to eq(activity)
      end

      it 'creates 2 boosts in total' do
        expect { subject }.to change { Boost.count }.by(2)
      end
    end

    describe '#punish_upvoters!' do
      subject { instance.punish_upvoters! }

      let(:instance) { FactoryBot.create(options[:factory], :with_up_and_downvotes) }
      let(:vote_1) { instance.upvotes.first }
      let(:vote_2) { instance.upvotes.second }

      before { expect_required_integer_env("#{class_name_env}_UPVOTER_PENALTY").and_return(-5) }

      it 'decreases all accept voters reputation by -5' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(-5).and \
          change { vote_2.reload.user.reputation }.by(-5)
      end

      it 'creates boosts (rep -5) for each upvoter which reference the transition_activity' do
        expect { subject }.to change { vote_1.reload.user.boosts.count }.by(1).and \
          change { vote_2.reload.user.boosts.count }.by(1)

        boost_1 = vote_1.user.boosts.last
        expect(boost_1.reputation).to eq(-5)
        expect(boost_1.activity).to eq(activity)

        boost_2 = vote_2.user.boosts.last
        expect(boost_2.reputation).to eq(-5)
        expect(boost_2.activity).to eq(activity)
      end

      it 'creates 2 boosts in total' do
        expect { subject }.to change { Boost.count }.by(2)
      end
    end

    describe '#award_downvoters!' do
      subject { instance.award_downvoters! }

      let(:instance) { FactoryBot.create(options[:factory], :with_up_and_downvotes) }
      let(:vote_1) { instance.downvotes.first }
      let(:vote_2) { instance.downvotes.second }

      before { expect_required_integer_env("#{class_name_env}_DOWNVOTER_PRIZE").and_return(2) }

      it 'increases all accept voters reputation by 2' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(2).and \
          change { vote_2.reload.user.reputation }.by(2)
      end

      it 'creates boosts (rep +2) for each upvoter which reference the transition_activity' do
        expect { subject }.to change { vote_1.reload.user.boosts.count }.by(1).and \
          change { vote_2.reload.user.boosts.count }.by(1)

        boost_1 = vote_1.user.boosts.last
        expect(boost_1.reputation).to eq(2)
        expect(boost_1.activity).to eq(activity)

        boost_2 = vote_2.user.boosts.last
        expect(boost_2.reputation).to eq(2)
        expect(boost_2.activity).to eq(activity)
      end

      it 'creates 2 boosts in total' do
        expect { subject }.to change { Boost.count }.by(2)
      end
    end

    describe '#punish_downvoters!' do
      subject { instance.punish_downvoters! }

      let(:instance) { FactoryBot.create(options[:factory], :with_up_and_downvotes) }
      let(:vote_1) { instance.downvotes.first }
      let(:vote_2) { instance.downvotes.second }

      before { expect_required_integer_env("#{class_name_env}_DOWNVOTER_PENALTY").and_return(-4) }

      it 'decreases all accept voters reputation by -4' do
        expect { subject }.to change { vote_1.reload.user.reputation }.by(-4).and \
          change { vote_2.reload.user.reputation }.by(-4)
      end

      it 'creates boosts (rep -4) for each upvoter which reference the transition_activity' do
        expect { subject }.to change { vote_1.reload.user.boosts.count }.by(1).and \
          change { vote_2.reload.user.boosts.count }.by(1)

        boost_1 = vote_1.user.boosts.last
        expect(boost_1.reputation).to eq(-4)
        expect(boost_1.activity).to eq(activity)

        boost_2 = vote_2.user.boosts.last
        expect(boost_2.reputation).to eq(-4)
        expect(boost_2.activity).to eq(activity)
      end

      it 'creates 2 boosts in total' do
        expect { subject }.to change { Boost.count }.by(2)
      end
    end
  end
end
