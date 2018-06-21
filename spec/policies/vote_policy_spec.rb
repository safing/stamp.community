RSpec.describe VotePolicy do
  subject { described_class.new(user, vote) }
  let(:vote) { FactoryBot.create(:vote) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
