RSpec.describe CommentPolicy do
  subject { described_class.new(user, comment) }
  let(:commentable) { FactoryBot.create(:label_stamp, state: state) }
  let(:comment) { FactoryBot.create(:comment, commentable: commentable) }
  let(:state) { :in_progress }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user) }

    context 'commentable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'commentable is archived' do
      let(:state) { :archived }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'commentable is denied' do
      let(:state) { :denied }
      it { is_expected.to forbid_new_and_create_actions }
    end

    context 'commentable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to forbid_new_and_create_actions }
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for a moderator' do
    let(:user) { FactoryBot.create(:moderator) }

    context 'commentable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is archived' do
      let(:state) { :archived }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is denied' do
      let(:state) { :denied }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to permit_new_and_create_actions }
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:admin) }

    context 'commentable is in_progress' do
      let(:state) { :in_progress }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is accepted' do
      let(:state) { :accepted }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is archived' do
      let(:state) { :archived }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is denied' do
      let(:state) { :denied }
      it { is_expected.to permit_new_and_create_actions }
    end

    context 'commentable is disputed' do
      let(:state) { :disputed }
      it { is_expected.to permit_new_and_create_actions }
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
