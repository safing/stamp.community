RSpec.feature 'comment requests', type: :request do
  describe 'authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(CommentPolicy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(CommentPolicy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#create' do
      subject(:request) { post stamp_comments_url(stamp.id), params: comment_attributes }
      let(:stamp) { FactoryBot.create(:label_stamp, state: state) }
      let(:state) { :in_progress }
      let(:comment_attributes) { { comment: { content: '1' * 40 } } }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 403
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end
  end

  describe 'activities' do
    describe '#create' do
      include_context 'login user'

      subject(:request) do
        post stamp_comments_url(stamp.id), params: { comment: comment_attributes }
      end

      let(:stamp) { FactoryBot.create(:label_stamp) }
      let(:comment_attributes) do
        FactoryBot.attributes_with_foreign_keys_for(:comment)
      end

      it "creates an 'comment.create' activity with {owner: current_user}" do
        PublicActivity.with_tracking do
          expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

          activity = PublicActivity::Activity.first
          expect(activity.key).to eq('comment.create')
          expect(activity.owner).to eq(controller.current_user)
          expect(activity.recipient).to eq(stamp)
        end
      end
    end
  end
end
