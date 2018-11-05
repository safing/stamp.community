RSpec.describe VotePolicy do
  subject { described_class.new(user, vote) }
  let(:votable) { FactoryBot.create(:label_stamp, state: state) }
  let(:vote) { FactoryBot.create(:vote, votable: votable) }
  let(:state) { :in_progress }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    context 'votable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'votable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is archived' do
      let(:state) { :archived }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is denied' do
      let(:state) { :denied }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to forbid_new_and_create_actions }
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    context 'votable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'votable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is archived' do
      let(:state) { :archived }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is denied' do
      let(:state) { :denied }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to forbid_new_and_create_actions }
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin) }

    context 'votable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'votable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is archived' do
      let(:state) { :archived }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is denied' do
      let(:state) { :denied }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'votable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to forbid_new_and_create_actions }
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
