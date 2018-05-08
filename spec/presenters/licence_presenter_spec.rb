RSpec.describe LicencePresenter::Entity do
  describe '.represent' do
    subject { LicencePresenter::Entity.represent(licence).as_json }

    let(:licence) { FactoryBot.create(:licence) }

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
  end
end
