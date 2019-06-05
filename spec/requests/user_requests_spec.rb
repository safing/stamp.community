RSpec.feature 'user requests', type: :request do
  describe 'authourization' do
    describe '#edit' do
      subject(:request) { get edit_user_path(id: targeted_user.id) }
      let(:targeted_user) { FactoryBot.create(:user) }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'targeted user is random user' do
        context 'role: user' do
          include_context 'login user'
          include_examples 'status code', 401
        end

        context 'role: moderator' do
          include_context 'login moderator'
          include_examples 'status code', 401
        end

        context 'role: admin' do
          include_context 'login admin'
          include_examples 'status code', 200
        end
      end

      context 'targeted user is current user' do
        let(:targeted_user) { current_user }

        before { sign_in(current_user) }

        context 'role: user' do
          let(:current_user) { FactoryBot.create(:user) }
          include_examples 'status code', 200
        end

        context 'role: moderator' do
          let(:current_user) { FactoryBot.create(:moderator) }
          include_examples 'status code', 200
        end

        context 'role: admin' do
          let(:current_user) { FactoryBot.create(:admin) }
          include_examples 'status code', 200
        end
      end
    end

    describe '#update' do
      subject(:request) { patch user_path(id: targeted_user.id), params: { user: user_attributes } }

      let(:targeted_user) { FactoryBot.create(:user) }
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'targeted user is random user' do
        context 'role: user' do
          include_context 'login user'
          include_examples 'status code', 401
        end

        context 'role: moderator' do
          include_context 'login moderator'
          include_examples 'status code', 401
        end

        context 'role: admin' do
          include_context 'login admin'
          include_examples 'status code', 302
        end
      end

      context 'targeted user is current user' do
        let(:targeted_user) { current_user }

        before { sign_in(current_user) }

        context 'role: user' do
          let(:current_user) { FactoryBot.create(:user) }
          include_examples 'status code', 302
        end

        context 'role: moderator' do
          let(:current_user) { FactoryBot.create(:moderator) }
          include_examples 'status code', 302
        end

        context 'role: admin' do
          let(:current_user) { FactoryBot.create(:admin) }
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
