RSpec.feature 'stamp requests', type: :request do
  describe 'authourization' do
    describe '#new' do
      subject(:request) { get new_stamp_url(domain_name: domain.name) }
      let(:domain) { FactoryBot.create(:domain) }

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
      let(:domain) { FactoryBot.create(:domain) }
      let(:stamp_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:label_stamp)
                  .merge(
                    comments_attributes: { '0': { content: '1' * 40 } },
                    domain: domain.name
                  )
      end

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 302
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 302
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 302
      end
    end

    describe '#show' do
      subject(:request) { get stamp_path(stamp) }

      let(:stamp) { FactoryBot.create(:label_stamp) }

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
