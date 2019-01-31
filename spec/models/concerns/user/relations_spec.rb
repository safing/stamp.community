RSpec.describe User, type: :model do
  describe '::Relations' do
    describe 'relations' do
      it { is_expected.to have_one(:api_key) }
      it { is_expected.to have_many(:domains).with_foreign_key(:user_id) }
      it { is_expected.to have_many(:stamps).with_foreign_key(:user_id) }
      it { is_expected.to have_many(:votes) }
      it { is_expected.to have_many(:comments) }
    end

    describe '#activities' do
      subject { user.activities }
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create_list(:domain_activity, 2, owner: user)
        FactoryBot.create_list(:app_activity, 2)
      end

      it 'returns all activities of the user' do
        expect(PublicActivity::Activity.count).to eq(4)
        expect(subject.count).to eq(2)
      end
    end

    describe '#domains' do
      subject { user.domains }
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create(:domain_activity, owner: user)
        FactoryBot.create(:domain_activity, owner: user, key: 'domain.update')
        FactoryBot.create(:domain_activity)
      end

      it 'returns all domains created by the user' do
        expect(PublicActivity::Activity.count).to eq(3)
        expect(subject.count).to eq(1)
      end
    end
  end
end
