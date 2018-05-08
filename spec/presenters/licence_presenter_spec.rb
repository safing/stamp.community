RSpec.describe LicencePresenter::Entity do
  describe '.represent' do
    subject { LicencePresenter::Entity.represent(licence, with_labels: with_labels).as_json }

    let(:licence) { FactoryBot.create(:licence) }
    let(:with_labels) { nil }

    it 'id as Integer' do
      expect(subject[:id]).to be_an(Integer)
      expect(subject[:id]).to eq(licence.id)
    end

    it 'name as String' do
      expect(subject[:name]).to be_a(String)
      expect(subject[:name]).to eq(licence.name)
    end

    it 'description as String' do
      expect(subject[:description]).to be_a(String)
      expect(subject[:description]).to eq(licence.description)
    end

    context 'options[:with_labels] is true' do
      let(:licence) { FactoryBot.create(:licence, :with_labels) }
      let(:with_labels) { true }

      it 'presents the licence#labels' do
        expect(subject[:labels]).not_to be_nil
        expect(subject[:labels].first[:name]).to be_an(String)
      end
    end
  end
end
