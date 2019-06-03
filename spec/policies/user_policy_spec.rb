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

  describe '#permitted_attributes' do
    subject { policy.permitted_attributes }

    let(:policy) { UserPolicy.new(user, targeted_user) }
    let(:user) { FactoryBot.create(:user) }

    context 'targeted_user is current user' do
      let(:targeted_user) { user }

      context 'user can view_flag_stamps?' do
        before { expect(policy).to receive(:view_flag_stamps?).and_return(true) }

        it 'returns [:description, :flag_stamps]' do
          expect(subject).to eq([:description, :flag_stamps])
        end
      end

      context 'user cannot view_flag_stamps?' do
        before { expect(policy).to receive(:view_flag_stamps?).and_return(false) }

        it 'returns [:description]' do
          expect(subject).to eq([:description])
        end
      end
    end

    context 'targeted_user is another user' do
      let(:targeted_user) { user }

      it 'returns [:description]' do
        expect(subject).to eq([:description])
      end
    end
  end
end
