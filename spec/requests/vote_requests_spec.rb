RSpec.feature 'vote requests', type: :request do
  describe 'authentication & authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(VotePolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(VotePolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#create' do
      subject(:request) { post stamp_votes_url(stamp.id), params: { vote: { accept: true } } }
      let(:stamp) { FactoryBot.create(:label_stamp) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
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

      it "creates a 'vote.create' activity with {owner: current_user, recipient: stamp}" do
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
