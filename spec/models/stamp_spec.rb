RSpec.describe Stamp do
  describe '#domain?' do
    subject { stamp.domain? }
    let(:stamp) { FactoryBot.create(:stamp) }

    context 'stampable_type is domain' do
      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'stampable_type is not domain' do
      # TODO: implement when adding another stampable model
      # it 'returns false' do
      #   expect(subject).to be false
      # end
    end
  end
end
