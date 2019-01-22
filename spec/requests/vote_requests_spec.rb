RSpec.feature 'vote requests', type: :request do
  describe 'authourization' do
    describe '#create' do
      subject(:request) { post stamp_votes_url(stamp.id), params: vote_attributes }
      let(:stamp) { FactoryBot.create(:label_stamp, state: state) }
      let(:state) { :in_progress }
      let(:vote_attributes) { { vote: { accept: true } } }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'

        context 'state is :in_progress' do
          let(:state) { :in_progress }
          include_examples 'status code', 302
        end

        context 'state is :accepted' do
          let(:state) { :accepted }
          include_examples 'status code', 401
        end

        context 'state is :archived' do
          let(:state) { :archived }
          include_examples 'status code', 401
        end

        context 'state is :denied' do
          let(:state) { :denied }
          include_examples 'status code', 401
        end

        context 'state is :disputed' do
          let(:state) { :disputed }
          include_examples 'status code', 401
        end
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 302
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 302
      end
    end
  end

  describe 'activities' do
    describe '#create' do
      include_context 'login user'

      subject(:request) do
        post stamp_votes_url(stamp.id), params: { vote: { accept: true } }
      end

      let(:stamp) { FactoryBot.create(:label_stamp) }

      it "creates an 'vote.create' activity with {owner: current_user}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.owner).to eq(controller.current_user)
          expect(activity.recipient).to eq(stamp)
        end
      end
    end
  end
end
