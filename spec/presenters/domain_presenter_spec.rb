RSpec.describe DomainPresenter::Entity do
  describe '.represent' do
    subject { DomainPresenter::Entity.represent(domain, with_stamps: with_stamps).as_json }

    let(:domain) { FactoryBot.create(:domain, parent: parent) }
    let(:parent) { nil }
    let(:with_stamps) { nil }

    it 'name as String' do
      expect(subject[:name]).to be_a(String)
      expect(subject[:name]).to eq(domain.name)
    end

    it 'user_id as Integer' do
      expect(subject[:user_id]).to be_an(Integer)
      expect(subject[:user_id]).to eq(domain.user_id)
    end

    context 'domain has a parent' do
      let(:parent) { FactoryBot.create(:domain) }

      it 'parent_id as Integer' do
        expect(subject).to include(:parent_id)
        expect(subject[:parent_id]).to be_an(Integer)
        expect(subject[:parent_id]).to eq(domain.parent_id)
      end

      it 'parent_name as String' do
        expect(subject).to include(:parent_name)
        expect(subject[:parent_name]).to be_an(String)
        expect(subject[:parent_name]).to eq(domain.parent_name)
      end
    end

    context 'domain has no parent' do
      it 'does not include parent_id' do
        expect(subject).not_to include(:parent_id)
      end

      it 'does not include parent_name' do
        expect(subject).not_to include(:parent_name)
      end
    end

    context 'options[:with_stamps] is true' do
      let(:with_stamps) { true }
      let(:domain) { FactoryBot.create(:domain, :with_stamps) }

      it 'presents the domain#stamps' do
        expect(subject[:stamps]).not_to be_nil
        expect(subject[:stamps].first[:percentage]).to be_an(Integer)
      end
    end
  end
end
