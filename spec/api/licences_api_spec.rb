RSpec.describe V1::LabelsAPI, type: :request do
  let!(:licences) { FactoryBot.create_list(:licence, 5) }
  let(:licence) { licences.first }

  describe 'GET v1/licences' do
    subject(:request) { get '/v1/licences' }

    it 'returns licences' do
      subject
      expect(json['licences']).not_to be_empty
      expect(json['licences'].size).to eq(5)
    end
  end

  describe 'GET v1/licences/:id' do
    subject(:request) { get "/v1/licences/#{licence.id}" }

    context 'when the licence exists' do
      it 'returns the licence' do
        subject
        expect(json['id']).to eq(licence.id)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when the licence does not exist' do
      before { licence.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Licence/)
      end
    end
  end

  describe 'GET v1/licences/:id/labels' do
    subject(:request) { get "/v1/licences/#{licence.id}/labels" }

    context 'when the licence exists' do
      it 'returns the licence' do
        subject
        expect(json['id']).to eq(licence.id)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end

      context 'licence has labels' do
        let(:licence) { FactoryBot.create(:licence, :with_labels) }

        it 'includes the labels of the licence' do
          subject
          expect(json['labels'].size).to be > 0
        end
      end

      context 'licence does not have any labels' do
        it 'includes an empty array for :labels' do
          subject
          expect(json['labels'].size).to eq(0)
          expect(json['labels']).to eq([])
        end
      end
    end

    context 'when the licence does not exist' do
      before { licence.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Licence/)
      end
    end
  end
end
