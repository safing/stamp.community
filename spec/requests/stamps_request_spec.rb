RSpec.describe 'stamp request', type: :request do
  describe 'new' do
    subject(:request) { get new_stamp_url }

    describe 'authourization' do
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
  end

  describe 'create' do
    subject(:request) { post stamps_url, params: { stamp: stamp_attributes } }
    let(:stamp_attributes) { FactoryBot.attributes_with_foreign_keys_for(:stamp) }

    describe 'authourization' do
      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 201
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 201
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 201
      end
    end
  end

  describe 'show' do
    subject(:request) { get stamps_path(stamp) }

    let(:stamp) { FactoryBot.create(:stamp) }

    describe 'authourization' do
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
end
