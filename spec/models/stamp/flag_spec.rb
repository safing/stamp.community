RSpec.describe Stamp::Flag, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:flag_stamp)).to be_valid
  end
end
