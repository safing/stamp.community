RSpec.describe Stamp::FlagPolicy do
  subject { described_class.new(user, stamp) }
  let(:stamp) { FactoryBot.create(:flag_stamp) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin, flag_stamps: flag_stamps) }
    let(:flag_stamps) { false }

    it { is_expected.to forbid_edit_and_update_actions }

    context 'admin has set his config#flag_stamps to false' do
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_action(:show) }
    end

    context 'admin has set his config#flag_stamps to true' do
      let(:flag_stamps) { true }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_action(:show) }
    end
  end
end
