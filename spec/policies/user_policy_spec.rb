RSpec.describe UserPolicy do
  subject { described_class.new(current_user, user) }
  let(:user) { FactoryBot.create(:user) }

  context 'for a visitor' do
    let(:current_user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:current_user) { FactoryBot.create(:user) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
  end
end
