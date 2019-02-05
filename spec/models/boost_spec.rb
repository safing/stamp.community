RSpec.describe Boost, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:boost)).to be_valid
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user).required(true) }
    it do
      is_expected.to belong_to(:activity).class_name('PublicActivity::Activity')
                                         .with_foreign_key(:activity_id)
                                         .required(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:activity) }
    it { is_expected.to validate_presence_of(:reputation) }

    describe '#reputation other_than: 0' do
      it { is_expected.to validate_numericality_of(:reputation) }
      it { is_expected.to allow_value(1).for(:reputation) }
      it { is_expected.to allow_value(10).for(:reputation) }
      it { is_expected.to allow_value(1000).for(:reputation) }
      it { is_expected.to allow_value(-1).for(:reputation) }
      it { is_expected.to allow_value(-10).for(:reputation) }
      it { is_expected.to allow_value(-1000).for(:reputation) }

      it { is_expected.not_to allow_value(0).for(:reputation) }
    end
  end

  describe 'database' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:activity_id) }
  end
end
