RSpec.feature 'domain requests', type: :request do
  describe 'authourization' do
    describe '#new' do
      subject(:request) { get new_domain_url }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end

    describe '#create' do
      # TODO: add specs for the format.js response
    end

    describe '#show' do
      subject(:request) { get domain_path(domain.name) }

      let(:domain) { FactoryBot.create(:domain) }

      context 'role: guest' do
        include_examples 'status code', 200
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end
  end

  describe 'activities' do
    describe '#create' do
      include_context 'login user'

      subject(:request) { post domains_url, xhr: true, params: { domain: domain_attributes } }
      let(:domain_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:domain)
      end

      before do
        allow_any_instance_of(Domain).to receive(:url_exists?).and_return(true)
      end

      it "creates an 'domain.create' activity with {owner: current_user}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(controller.current_user).to eq(activity.owner)
        end
      end
    end
  end
end
