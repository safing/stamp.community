RSpec.feature 'domain requests', type: :request do
  describe 'authentication & authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(DomainPolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(DomainPolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#new' do
      subject(:request) { get new_domain_url }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end

    describe '#create' do
      # TODO: add specs for the format.js response
    end

    describe '#show' do
      subject(:request) { get domain_path(domain.name) }
      let(:domain) { FactoryBot.create(:domain) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 200
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
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
