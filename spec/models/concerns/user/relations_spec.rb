RSpec.describe User, type: :model do
  describe '::Relations' do
    describe 'relations' do
      it { is_expected.to have_one(:api_key) }
      it { is_expected.to have_many(:domains).with_foreign_key(:user_id) }
      it { is_expected.to have_many(:stamps).with_foreign_key(:user_id) }
      it { is_expected.to have_many(:votes) }
      it { is_expected.to have_many(:comments) }
      it { is_expected.to have_many(:boosts) }
      it do
        is_expected.to have_many(:activities).class_name('PublicActivity::Activity')
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
