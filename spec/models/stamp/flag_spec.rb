RSpec.describe Stamp::Flag, type: :model do
  it_behaves_like 'a STI child of Stamp', factory: :flag_stamp

  it 'has a valid factory' do
    expect(FactoryBot.create(:flag_stamp)).to be_valid
  end

  describe 'fields' do
    let(:flag_stamp) { Stamp::Flag.new }

    it '#internet is set by default, has getter and setter' do
      expect(flag_stamp.internet).to be false
      flag_stamp.internet = true
      expect(flag_stamp.internet).to be true
    end

    it '#lan is set by default, has getter and setter' do
      expect(flag_stamp.lan).to be false
      flag_stamp.lan = true
      expect(flag_stamp.lan).to be true
    end

    it '#localhost is set by default, has getter and setter' do
      expect(flag_stamp.localhost).to be false
      flag_stamp.localhost = true
      expect(flag_stamp.localhost).to be true
    end

    it '#prompt is set by default, has getter and setter' do
      expect(flag_stamp.prompt).to be false
      flag_stamp.prompt = true
      expect(flag_stamp.prompt).to be true
    end

    it '#blacklist is set by default, has getter and setter' do
      expect(flag_stamp.blacklist).to be false
      flag_stamp.blacklist = true
      expect(flag_stamp.blacklist).to be true
    end

    it '#whitelist is set by default, has getter and setter' do
      expect(flag_stamp.whitelist).to be false
      flag_stamp.whitelist = true
      expect(flag_stamp.whitelist).to be true
    end

    it '#server is set by default, has getter and setter' do
      expect(flag_stamp.server).to be false
      flag_stamp.server = true
      expect(flag_stamp.server).to be true
    end

    it '#p2p is set by default, has getter and setter' do
      expect(flag_stamp.p2p).to be false
      flag_stamp.p2p = true
      expect(flag_stamp.p2p).to be true
    end
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:stampable_type).in_array(['App']) }

    describe 'GroupValidator' do
      describe '#one_in_each_group_must_be_true' do
        subject { flag_stamp.valid? }
        let(:group_hash) { {} }

        # rubocop:disable Security/Eval
        # =>  {internet: false, lan: false, localhost: false}
        before { group.map { |e| group_hash[e] = eval(e.to_s) } }
        # rubocop:enable Security/Eval

        let(:flag_stamp) do
          FactoryBot.build(:flag_stamp, **group_hash)
        end

        describe '[:prompt, :blacklist, :whitelist]' do
          let(:group) { %i[prompt blacklist whitelist] }
          let(:prompt) { false }
          let(:blacklist) { false }
          let(:whitelist) { false }

          context 'two flags are set to true' do
            let(:prompt) { true }
            let(:whitelist) { true }

            it 'returns false' do
              expect(subject).to be false
              expect(flag_stamp.errors.full_messages.first).to include('*one* must be set to true')
            end
          end

          context 'one flags is set to true' do
            let(:blacklist) { true }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context 'no flag is set to true' do
            it 'returns false' do
              expect(subject).to be false
              expect(flag_stamp.errors.full_messages.first).to include('*one* must be set to true')
            end
          end
        end
      end
    end
  end
end
