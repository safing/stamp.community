RSpec.describe LabelPolicy do
  subject { described_class.new(user, label) }
  let(:label) { FactoryBot.create(:label) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_edit_and_update_actions }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin) }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_edit_and_update_actions }
  end

  describe '#permitted_attributes' do
    subject { policy.permitted_attributes }
    let(:policy) { LabelPolicy.new(user, Label.new) }

    context 'user is a admin' do
      let(:user) { FactoryBot.create(:admin) }

      it 'returns [:name, :description, :licence_id, :parent_id]' do
        expect(subject).to eq([:name, :description, :licence_id, :parent_id])
      end
    end

    context 'user is a moderator' do
      let(:user) { FactoryBot.create(:moderator) }

      it 'returns [:description]' do
        expect(subject).to eq([:description])
      end
    end
  end
end
