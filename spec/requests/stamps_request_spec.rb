# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.describe 'stamp requests', type: :request do
  describe 'authourization' do
    describe '#new' do
      subject(:request) { get new_stamp_url }

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
      subject(:request) { post stamps_url, params: { stamp: stamp_attributes } }
      let(:stamp_attributes) { FactoryBot.attributes_with_foreign_keys_for(:stamp) }

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

    describe 'show' do
      subject(:request) { get stamps_path(stamp) }

      let(:stamp) { FactoryBot.create(:stamp) }

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
