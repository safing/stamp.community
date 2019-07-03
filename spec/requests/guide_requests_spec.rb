RSpec.feature 'guide requests', type: :request do
  describe 'authentication' do
    describe '#tour' do
      subject(:request) { get tour_path }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 200
      end

      context 'user is authenticated' do
        include_context 'login user'
        include_examples 'status code', 200
      end
    end

    describe '#label_stamps' do
      subject(:request) { get label_stamps_guide_path }

      before do
        FactoryBot.create(:label, name: 'Ads')
        FactoryBot.create(:label, name: 'Analytics')
      end

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 200
      end

      context 'user is authenticated' do
        include_context 'login user'
        include_examples 'status code', 200
      end
    end
  end
end
