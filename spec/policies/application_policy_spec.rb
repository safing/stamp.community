RSpec.describe ApplicationPolicy do
  subject { described_class.new(user, nil) }

  context 'for a visitor' do
    let(:user) { nil }
    it { is_expected.to forbid_action(:view_flag_stamps) }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }
    it { is_expected.to forbid_action(:view_flag_stamps) }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }
    it { is_expected.to forbid_action(:view_flag_stamps) }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin, flag_stamps: flag_stamps) }

    context 'admin has set his config#flag_stamps to false' do
      let(:flag_stamps) { false }
      it { is_expected.to forbid_action(:view_flag_stamps) }
    end

    context 'admin has set his config#flag_stamps to true' do
      let(:flag_stamps) { true }
      it { is_expected.to permit_action(:view_flag_stamps) }
    end
  end
end
