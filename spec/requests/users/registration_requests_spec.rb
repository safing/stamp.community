RSpec.feature 'registration requests', type: :request do
  # theses specs are all dependent on Activity tracking
  around do |test|
    PublicActivity.with_tracking do
      test.run
    end
  end
  describe 'activities' do
    describe '#create' do
      subject(:request) { post user_registration_path, params: { user: user_attributes } }
      let(:user_attributes) do
        FactoryBot.attributes_for(:user).slice(:email, :username, :password)
      end

      it "creates an 'user.signed_up' activity with {owner: user, trackable: user}" do
        expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

        user = User.last
        activity = PublicActivity::Activity.first
        expect(activity.key).to eq("user.signup")
        expect(activity.owner).to eq(user)
        expect(activity.trackable).to eq(user)
        expect(activity.recipient).to eq(nil)
      end
    end
  end
end
