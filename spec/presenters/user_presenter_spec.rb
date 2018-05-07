RSpec.describe UserPresenter::Entity do
  describe '.represent' do
    subject { UserPresenter::Entity.represent(user).as_json }
    let(:user) { FactoryBot.create(:user) }

    it 'id as Integer' do
      expect(subject[:id]).to be_an(Integer)
      expect(subject[:id]).to eq(user.id)
    end

    it 'reputation as Integer' do
      expect(subject[:reputation]).to be_an(Integer)
      expect(subject[:reputation]).to eq(user.reputation)
    end

    it 'voting_power as Integer' do
      expect(subject[:voting_power]).to be_an(Integer)
      expect(subject[:voting_power]).to eq(user.voting_power)
    end

    it 'username as String' do
      expect(subject[:username]).to be_a(String)
      expect(subject[:username]).to eq(user.username)
    end
  end
end
