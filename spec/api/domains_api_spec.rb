require 'spec_helper'

RSpec.describe V1::DomainsAPI, type: :request do
  let!(:domains) { FactoryBot.create_list(:domain, 10) }
  let(:domain) { domains.first }

  describe 'GET v1/domains/:name' do
    subject(:request) { get "/v1/domains/#{domain.name}" }

    context 'when the record exists' do
      it 'returns the domain' do
        subject
        expect(json).not_to be_empty
        expect(json['name']).to eq(domain.name)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { domain.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Domain/)
      end
    end
  end

  describe 'GET domains/:name/stamps' do
    subject(:request) { get "/v1/domains/#{domain.name}/stamps" }

    context 'when the domain exists' do
      it 'returns the domain' do
        subject
        expect(json['name']).to eq(domain.name)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(200)
      end

      context 'domain has stamps' do
        let(:domain) { FactoryBot.create(:domain, :with_stamps) }

        it 'includes the stamps of the domain' do
          subject
          expect(json['stamps'].size).to be > 0
        end
      end

      context 'domain does not have any stamps' do
        it 'includes an empty array for :stamps' do
          subject
          expect(json['stamps'].size).to eq(0)
          expect(json['stamps']).to eq([])
        end
      end
    end

    context 'when the domain does not exist' do
      before { domain.delete }

      it 'returns status code 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(response.body).to match(/Couldn't find Domain/)
      end
    end
  end
end
