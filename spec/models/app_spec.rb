RSpec.describe App, type: :model do
  it_behaves_like 'PublicActivity::Recipient', factory: :app

  it 'has a valid factory' do
    expect(FactoryBot.create(:app)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to have_many(:stamps) }
  end

  describe 'database' do
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

    describe 'link validation' do
      it { is_expected.to allow_value('i.oh1.me').for(:link) }
      it { is_expected.to allow_value('assets.fb.com').for(:link) }
      it { is_expected.to allow_value('uni.ac.uk').for(:link) }
      it { is_expected.to allow_value('we.do.many.subs.ac.uk').for(:link) }
      it { is_expected.to allow_value('www.uni.ac.uk').for(:link) }
      it { is_expected.to allow_value('www.xn--cybr-noa.space').for(:link) }
      it { is_expected.to allow_value('x.com').for(:link) }
      it { is_expected.to allow_value('https://x.com').for(:link) }
      it { is_expected.to allow_value('http://x.com').for(:link) }

      it { is_expected.not_to allow_value('i.ehthe.oh1.me.').for(:link) }
      it { is_expected.not_to allow_value('e//assets.fb.com').for(:link) }
      it { is_expected.not_to allow_value('uni.').for(:link) }
      it { is_expected.not_to allow_value('no-dot-nono').for(:link) }
      it { is_expected.not_to allow_value('.uni').for(:link) }
      it { is_expected.not_to allow_value('x.com/oahethutoa').for(:link) }
      it { is_expected.not_to allow_value(')*)xn--cybr-noa.space').for(:link) }
    end

    describe 'before_validation callback' do
      subject { app.save }

      let(:app) { FactoryBot.build(:app, link: link) }

      context 'link has no http(s)://' do
        let(:link) { 'x.com' }

        it 'does not change the link' do
          expect(app.link).to eq(link)
          subject
          expect(app.reload.link).to eq(link)
        end
      end

      context 'link start with https://' do
        let(:link) { 'https://x.com' }
        it 'strips https:// from link before validating' do
          expect(app.link).to include('https://')
          subject
          expect(app.reload.link).not_to include('https://')
        end
      end

      context 'link start with http://' do
        let(:link) { 'http://x.com' }

        it 'strips http:// from link before validating' do
          expect(app.link).to include('http://')
          subject
          expect(app.reload.link).not_to include('http://')
        end
      end
    end
  end
end
