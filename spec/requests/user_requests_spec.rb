RSpec.feature 'user requests', type: :request do
  describe 'authentication & authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(UserPolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(UserPolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#edit' do
      subject(:request) { get edit_user_path(id: targeted_user.id) }
      let(:targeted_user) { FactoryBot.create(:user) }

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

    describe '#update' do
      subject(:request) { patch user_path(id: targeted_user.id), params: { user: user_attributes } }

      let(:targeted_user) { FactoryBot.create(:user) }
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

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
          include_examples 'status code', 302
        end
      end
    end
  end

  describe '#update' do
    subject(:request) { patch user_path(id: user.id), params: { user: user_attributes } }

    let(:user) { FactoryBot.create(:user) }
    let(:user_attributes) { FactoryBot.attributes_for(:user, :with_description) }

    include_context 'login user'

    it 'calls UserPolicy#permitted_attributes' do
      expect_any_instance_of(UserPolicy).to receive(:permitted_attributes).and_call_original
      request
    end
  end
end
