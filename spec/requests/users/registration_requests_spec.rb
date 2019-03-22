RSpec.feature 'registration requests', type: :request do
  include_context 'with activity tracking'

  describe 'POST /users' do
    subject(:request) { post user_registration_path, params: { user: user_attributes } }
    let(:user_attributes) do
      FactoryBot.attributes_for(:user).slice(:email, :username, :password)
    end

    context 'USER_INITIAL_REPUTATION is 0' do
      before { allow_required_integer_env('USER_INITIAL_REPUTATION').and_return(0) }

      it 'sets user rep to 0' do
        subject
        expect(User.last.reputation).to eq(0)
      end

      it 'does not create a user boosts' do
        expect { subject }.not_to change { Boost.count }
      end
    end

    context 'USER_INITIAL_REPUTATION is 1' do
      before { allow_required_integer_env('USER_INITIAL_REPUTATION').and_return(1) }

      # indirect spec to test counter_culture
      it 'sets user rep to 1' do
        subject
        expect(User.last.reputation).to eq(1)
      end

      it 'creates a user boost (rep +1) and links to the user.signup activity (cause & trigger)' do
        expect { subject }.to change { Boost.count }.from(0).to(1)

        boost = Boost.last
        activity = PublicActivity::Activity.last
        expect(boost.reputation).to eq(1)
        expect(boost.cause).to eq(activity)
        expect(boost.trigger).to eq(activity)
      end
    end
  end

  describe 'activities' do
    describe '#create' do
      subject(:request) { post user_registration_path, params: { user: user_attributes } }
      let(:user_attributes) do
        FactoryBot.attributes_for(:user).slice(:email, :username, :password)
      end

      it "creates a 'user.signed_up' activity with {owner: user, trackable: user}" do
        expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

        user = User.last
        activity = PublicActivity::Activity.first
        expect(activity.key).to eq('user.signup')
        expect(activity.owner).to eq(user)
        expect(activity.trackable).to eq(user)
        expect(activity.recipient).to eq(nil)
      end
    end
  end
end
