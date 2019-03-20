RSpec.shared_examples 'a STI child of Stamp' do |options|
  it_behaves_like 'a votable model', factory: options[:factory]
  it_behaves_like 'a rewardable model', factory: options[:factory]
  it_behaves_like 'PublicActivity::Recipient', factory: options[:factory]

  subject { stamp }
  let(:stamp) { FactoryBot.create(options[:factory]) }

  describe 'factories' do
    subject { FactoryBot.create(options[:factory], :with_votes, activities: activities) }

    describe 'trait :with_votes' do
      context 'activities is false' do
        let(:activities) { false }

        it 'creates a stamp with 2 upvotes & 2 downvotes' do
          expect { subject }.to change { Stamp.count }.from(0).to(1)

          stamp = Stamp.last
          expect(stamp.upvotes.count).to eq(2)
          expect(stamp.downvotes.count).to eq(2)
        end

        it 'does not create any activities' do
          expect { subject }.not_to change { PublicActivity::Activity.count }
        end
      end

      context 'activities is true' do
        let(:activities) { true }

        it 'creates a stamp with 2 upvotes & 2 downvotes' do
          expect { subject }.to change { Stamp.count }.from(0).to(1)

          stamp = Stamp.last
          expect(stamp.upvotes.count).to eq(2)
          expect(stamp.downvotes.count).to eq(2)
        end

        it 'creates exactly 4 activities (fitting to the up & downvotes)' do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(4)
        end
      end
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:comments) }
    it { is_expected.to belong_to(:creator).class_name('User').required(true) }
    it { is_expected.to belong_to(:stampable).required(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_inclusion_of(:type).in_array(%w[Stamp::Flag Stamp::Label]) }
    it { is_expected.to validate_presence_of(:creator) }
    it { is_expected.to validate_presence_of(:stampable) }
    it { is_expected.to validate_presence_of(:state) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[stampable_type stampable_id]) }
  end

  describe '#peers' do
    subject { stamp.peers }

    context 'stamp has no peers' do
      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'stamp has peers' do
      before { stamp.stampable.stamps << FactoryBot.create_list(options[:factory], 2) }

      it 'returns all peers' do
        expect(subject.count).to eq(2)
      end

      it 'does not return itself' do
        expect(subject.pluck(:id)).not_to include(stamp.id)
      end
    end
  end

  describe '#commenter_ids' do
    subject { stamp.commenter_ids }
    let(:stamp) { FactoryBot.create(options[:factory], :with_comments) } # 3 comments

    before { FactoryBot.create(:comment) }

    it 'returns all user_ids of people who commented on the stamp' do
      expect(subject).to be_a(Array)
      expect(subject.count).to eq(3)
    end
  end

  describe 'stamp#param_key(base_class:)' do
    subject { stamp.param_key(base_class: base_class) }

    context 'base_class is true' do
      let(:base_class) { true }

      context "instance is a :#{options[:factory]}" do
        it 'returns :stamp' do
          expect(subject).to eq('stamp')
        end
      end

      context 'instance is a :stamp' do
        let(:stamp) { Stamp.new(type: 'Stamp') }

        it 'returns :stamp' do
          expect(subject).to eq('stamp')
        end
      end
    end

    context 'base_class is false' do
      let(:base_class) { false }

      context "instance is a :#{options[:factory]}" do
        it "returns :#{options[:factory]}" do
          expect(subject).to eq(options[:factory].to_s)
        end
      end

      context 'instance is a :stamp' do
        let(:stamp) { Stamp.new(type: 'Stamp') }

        it 'returns :stamp' do
          expect(subject).to eq('stamp')
        end
      end
    end
  end

  describe "#key_for(action: 'create')" do
    subject { stamp.key_for(base_class: false, action: 'create') }

    context "instance is a :#{options[:factory]}" do
      it 'returns flag_stamp.create' do
        expect(subject).to eq("#{options[:factory]}.create")
      end
    end

    context 'instance is a :stamp' do
      let(:stamp) { Stamp.new(type: 'Stamp') }

      it 'returns stamp.create' do
        expect(subject).to eq('stamp.create')
      end
    end
  end

  describe '#creation_activity' do
    subject { stamp.creation_activity }

    context 'activity exists' do
      let(:stamp) { FactoryBot.create(options[:factory], :with_creation_activity) }

      it 'returns the creation activity' do
        expect(subject).to eq(PublicActivity::Activity.last)
      end
    end

    context 'activity does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
