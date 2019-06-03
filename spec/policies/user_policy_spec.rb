RSpec.describe UserPolicy do
  subject { described_class.new(user, targeted_user) }
  let(:targeted_user) { FactoryBot.create(:user) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:view_flag_stamps) }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:view_flag_stamps) }

    context 'updating himself' do
      let(:targeted_user) { user }
      it { is_expected.to permit_edit_and_update_actions }
    end

    context 'updating another user' do
      it { is_expected.to forbid_edit_and_update_actions }
    end
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:view_flag_stamps) }

    context 'updating himself' do
      let(:targeted_user) { user }
      it { is_expected.to permit_edit_and_update_actions }
    end

    context 'updating another user' do
      it { is_expected.to forbid_edit_and_update_actions }
    end
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:view_flag_stamps) }

    context 'updating himself' do
      let(:targeted_user) { user }
      it { is_expected.to permit_edit_and_update_actions }
    end

    context 'updating another user' do
      it { is_expected.to permit_edit_and_update_actions }
    end

    context 'updating another admin' do
      let(:targeted_user) { FactoryBot.create(:admin) }

      it { is_expected.to forbid_edit_and_update_actions }
    end
  end
end
