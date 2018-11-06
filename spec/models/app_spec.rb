RSpec.describe App, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:app)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'fields' do
    let(:app) { App.new }

    it '#linux is set by default, has getter and setter' do
      expect(app.linux).to be false
      app.linux = true
      expect(app.linux).to be true
    end

    it '#macos is set by default, has getter and setter' do
      expect(app.macos).to be false
      app.macos = true
      expect(app.macos).to be true
    end

    it '#windows is set by default, has getter and setter' do
      expect(app.windows).to be false
      app.windows = true
      expect(app.windows).to be true
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:uuid) }

    describe '#supports_one_or_more_operating_systems' do
      subject { app.valid? }
      let(:app) { FactoryBot.build(:app, **group_hash) }
      let(:group) { %i[linux macos windows] }
      let(:group_hash) { {} }

      let(:linux) { false }
      let(:macos) { false }
      let(:windows) { false }

      # rubocop:disable Security/Eval
      # => { linux: false, macos: false, windows: false }
      before { group.map { |e| group_hash[e] = eval(e.to_s) } }
      # rubocop:enable Security/Eval

      context 'no operating system is set to true' do
        it 'returns false' do
          expect(subject).to be false
          expect(app.errors.full_messages.first).to(
            include('at least one operating system must be supported by the app')
          )
        end
      end

      context 'one operating system is set to true' do
        let(:windows) { true }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'two operating systems are set to true' do
        let(:linux) { true }
        let(:macos) { true }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'all operating systems are set to true' do
        let(:linux) { true }
        let(:macos) { true }
        let(:windows) { true }

        it 'returns true' do
          expect(subject).to be true
        end
      end
    end
  end
end
