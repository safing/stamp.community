RSpec.describe System, type: :model do
  describe '#new' do
    subject { System.new }

    it 'sets the #id to -1' do
      expect(subject.id).to eq(-1)
    end
  end

  describe '.polymorphic_name' do
    subject { System.polymorphic_name }

    it "returns 'System'" do
      expect(subject).to eq('System')
    end
  end

  describe 'System.new.activities' do
    subject { System.new.activities }
    before { FactoryBot.create(:app_activity) }

    context 'no system activities exist' do
      it 'returns no activities' do
        expect(subject.count).to eq(0)
      end
    end

    context 'system activities exist' do
      before { FactoryBot.create_list(:transition_activity, 2) }

      it 'returns all system activities' do
        expect(subject.count).to eq(2)
        expect(PublicActivity::Activity.count).to eq(3)
      end
    end
  end
end
