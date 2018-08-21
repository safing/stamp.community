# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.describe 'stamp requests', type: :request do
  describe 'authourization' do
    describe '#new' do
      subject(:request) { get new_stamp_url }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end

    describe '#create' do
      subject(:request) { post stamps_url, params: { stamp: stamp_attributes } }
      let(:stamp_attributes) { FactoryBot.attributes_with_foreign_keys_for(:stamp) }

      context 'role: guest' do
        include_examples 'status code', 401
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 201
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 201
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 201
      end
    end

    describe 'show' do
      subject(:request) { get stamps_path(stamp) }

      let(:stamp) { FactoryBot.create(:stamp) }

      context 'role: guest' do
        include_examples 'status code', 200
      end

      context 'role: user' do
        include_context 'login user'
        include_examples 'status code', 200
      end

      context 'role: moderator' do
        include_context 'login moderator'
        include_examples 'status code', 200
      end

      context 'role: admin' do
        include_context 'login admin'
        include_examples 'status code', 200
      end
    end
  end
  describe 'stamp show' do
    it 'links to the stamped domain'
    it 'shows other stamps of this domain'
    it 'shows suggested stamps of this domain'
    it 'shows user comments'

    context 'stamp is in_progress' do
      it 'shows the state in_progress'
      it 'does not show any results'
    end

    context 'stamp is accepted' do
      it 'shows the state accepted'
      it 'shows the stamp results'
    end

    context 'stamp is denied' do
      it 'shows the state denied'
      it 'shows the stamp results'
    end

    context 'stamp is disputed' do
      it 'shows the state disputed'
      it 'shows the stamp results'
    end

    context 'stamp is archived' do
      it 'shows the state archived'
      it 'shows the stamp results'
      it 'shows the currently accepted stamp'
    end

    context 'no user is signed in (guest)' do
      it 'does not link to a sibling-stamp# (new stamp for the same domain)'
    end

    context 'user is signed in (current_user)' do
      it 'links to a sibling-stamp# (new stamp for the same domain)'

      context 'current_user voted on the stamp' do
        it 'shows what current_user voted for'
        it 'shows the rewards for the vote of the current_user'

        context 'stamp is in_progress' do
          it 'allows user to comment'

          context 'current_user voted less than 5 minutes ago' do
            it 'allows user to change his vote'
          end

          context 'current_user voted more than 5 minutes ago' do
            it 'denies user to change his vote'
          end
        end
      end

      context 'current_user did not vote on the stamp' do
        context 'stamp is in_progress' do
          it 'allows user to comment'

          context 'current_user is the creator' do
            it 'denies user to vote on the stamp'
          end

          context 'current_user is not the creator' do
            it 'allows user to vote'
          end
        end
      end

      context 'stamp is accepted' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is denied' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is disputed' do
        it 'denies user to vote'
        it 'denies user to comment'
      end

      context 'stamp is archived' do
        it 'denies user to vote'
        it 'denies user to comment'
      end
    end
  end
end
