RSpec.describe LabelPresenter::Entity do
  describe '.represent' do
    subject { LabelPresenter::Entity.represent(label, with_stamps: with_stamps).as_json }

    let(:label) { FactoryBot.create(:label) }
    let(:with_stamps) { nil }

    it 'id as Integer' do
      expect(subject[:id]).to be_an(Integer)
      expect(subject[:id]).to eq(label.id)
    end

    it 'name as String' do
      expect(subject[:name]).to be_a(String)
      expect(subject[:name]).to eq(label.name)
    end

    it 'description as String' do
      expect(subject[:description]).to be_a(String)
      expect(subject[:description]).to eq(label.description)
    end

    context 'label has no parent' do
      it 'does not show the parent' do
        expect(subject[:parent]).to be_nil
      end
    end

    context 'label has a parent' do
      let(:parent) { FactoryBot.create(:label) }

      before { label.update(parent: parent) }

      it 'parent as LabelPresenter::Entity' do
        expect(subject[:parent]).not_to be_nil
        expect(subject[:parent][:id]).to be_an(Integer)
        expect(subject[:parent][:id]).to eq(parent.id)
        expect(subject[:parent][:name]).to be_a(String)
        expect(subject[:parent][:name]).to eq(parent.name)
        expect(subject[:parent][:description]).to be_a(String)
        expect(subject[:parent][:description]).to eq(parent.description)
      end
    end

    context 'options[:with_stamps] is true' do
      let(:with_stamps) { true }
      let(:label) { FactoryBot.create(:label, :with_stamps) }

      it 'presents the label#stamps' do
        expect(subject[:stamps]).not_to be_nil
        expect(subject[:stamps].first[:percentage]).to be_an(Integer)
      end
    end
  end
end
