RSpec.describe 'stamps/show.html.haml', type: :view do
  let(:stamp) { FactoryBot.create(:label_stamp, state: state) }
  let(:state) { :in_progress }

  def rendered
    assign(:stamp, stamp)
    assign(:commentable, stamp)
    assign(:comments, stamp.comments)
    assign(:comment, Comment.new)
    assign(:votable, stamp)
    assign(:vote, Vote.new)
    render
    super
  end

  shared_examples 'show: state' do |state|
    it "shows the state :#{state}" do
      expect(rendered).to have_content(state.to_s.titleize)
    end
  end

  shared_examples 'stamp with results' do
    it 'shows the stamp results' do
      expect(rendered).to have_content('Results')
    end

    it 'does not show the \'Add Comment\' button' do
      expect(rendered).not_to have_button('Add Comment')
    end

    # add specs to show the correct color of the vote buttons
    # depending on results & whether the user voted or not
  end

  it 'links to the stamped domain (http://safing.io)' do
    expect(rendered).to have_link(href: stamp.domain.href)
  end

  it 'links to the stamped domain on stamp (/domains/safing.io)' do
    expect(rendered).to have_link(href: domain_path(stamp.domain.name))
  end

  it 'shows the stamps label' do
    expect(rendered).to have_css('.container .ui.segment:first', text: stamp.label.name)
  end

  it 'shows the stamps percentage' do
    expect(rendered).to have_css('.ui.segment:first .ui.progress', text: stamp.percentage)
  end

  it 'shows: comments section' do
    expect(rendered).to have_css('.ui.comments')
  end

  context 'stamp is :in_progress' do
    let(:state) { :in_progress }

    include_context 'show: state', :in_progress

    it 'does not show any results' do
      expect(rendered).not_to have_content('Results')
    end

    context 'current_user is not set (guest)' do
      it 'does not show the \'Add Comment\' button' do
        expect(rendered).not_to have_button('Add Comment')
      end
    end

    context 'current_user is set' do
      include_context 'login user'
      it 'shows: \'Add Comment\' button' do
        expect(rendered).to have_button('Add Comment')
      end
    end
  end

  context 'stamp is :accepted' do
    let(:state) { :accepted }
    include_context 'show: state', :accepted
    it_behaves_like 'stamp with results'
  end

  context 'stamp is :denied' do
    let(:state) { :denied }
    include_context 'show: state', :denied
    it_behaves_like 'stamp with results'
  end

  context 'stamp is :disputed' do
    let(:state) { :disputed }
    include_context 'show: state', :disputed
    it_behaves_like 'stamp with results'
  end

  context 'stamp is :archived' do
    let(:state) { :archived }
    include_context 'show: state', :archived
    it_behaves_like 'stamp with results'

    it 'links to the currently accepted stamp'
  end

  describe '-- upvote / downvote buttons --' do
    shared_examples 'shows upvote button' do |color|
      it "shows upvote button in #{color}" do
        expect(rendered).to have_css("button.icon:first i.up.#{color}")
      end
    end

    shared_examples 'shows downvote button' do |color|
      it "shows downvote button in #{color}" do
        expect(rendered).to have_css("button.icon:last-child i.up.#{color}")
      end
    end

    shared_examples 'has: new form for' do |type, has|
      if has
        it "has a form for a new #{type}" do
          expect(rendered).to have_css("form#new_#{type}")
        end
      else
        it "does not have a form for a new #{type}" do
          expect(rendered).not_to have_css("form#new_#{type}")
        end
      end
    end

    context 'state is :in_progress' do
      let(:state) { :in_progress }

      context 'current_user is not set (guest)' do
        include_context 'shows upvote button', :grey
        include_context 'shows downvote button', :grey
      end

      context 'current_user is set' do
        let(:user) { FactoryBot.create(:user) }
        include_context 'login user'

        context 'user did not vote on stamp' do
          include_context 'shows upvote button', :grey
          include_context 'shows downvote button', :grey
          include_context 'has: new form for', 'upvote', true
          include_context 'has: new form for', 'downvote', true
        end

        context 'user voted on stamp' do
          context 'user upvoted' do
            before do
              FactoryBot.create(:upvote, votable: stamp, user: user, created_at: created_at)
            end
            let(:created_at) { Time.current }

            include_context 'has: new form for', 'upvote', false
            include_context 'has: new form for', 'downvote', false

            context 'user voted less than 5 minutes ago' do
              let(:created_at) { 4.minutes.ago }

              it 'has the downvote form to change his vote'
              # include_context 'has: new form for', 'downvote', true
            end

            context 'user voted more than 5 minutes ago' do
              let(:created_at) { 6.minutes.ago }
              it 'does no longer have a downvote form to change his vote'
              # include_context 'has: new form for', 'downvote', false
            end

            include_context 'shows upvote button', :purple
            include_context 'shows downvote button', :grey
          end

          context 'user downvoted' do
            before do
              FactoryBot.create(:downvote, votable: stamp, user: user, created_at: created_at)
            end
            let(:created_at) { Time.current }

            include_context 'has: new form for', 'upvote', false
            include_context 'has: new form for', 'downvote', false

            context 'user voted less than 5 minutes ago' do
              let(:created_at) { 4.minutes.ago }
              it 'does no longer have a upvote form to change his vote'
              # include_context 'has: new form for', 'upvote', true
            end

            context 'user voted more than 5 minutes ago' do
              let(:created_at) { 6.minutes.ago }
              it 'has the upvote form to change his vote'
              # include_context 'has: new form for', 'upvote', false
            end

            include_context 'shows upvote button', :grey
            include_context 'shows downvote button', :purple
          end
        end
      end
    end

    context 'state is :accepted' do
      let(:state) { :accepted }

      include_context 'has: new form for', 'upvote', false
      include_context 'has: new form for', 'downvote', false

      context 'current_user is not set (guest)' do
        include_context 'shows upvote button', :grey
        include_context 'shows downvote button', :grey
      end

      context 'current_user is set' do
        let(:user) { FactoryBot.create(:user) }
        include_context 'login user'

        context 'user did not vote on stamp' do
          include_context 'shows upvote button', :grey
          include_context 'shows downvote button', :grey
        end

        context 'user voted on stamp' do
          context 'user upvoted' do
            before { FactoryBot.create(:upvote, votable: stamp, user: user) }

            include_context 'shows upvote button', :green
            include_context 'shows downvote button', :grey
          end

          context 'user downvoted' do
            before { FactoryBot.create(:downvote, votable: stamp, user: user) }

            include_context 'shows upvote button', :grey
            include_context 'shows downvote button', :red
          end
        end
      end
    end

    context 'state is :denied' do
      let(:state) { :denied }

      include_context 'has: new form for', 'upvote', false
      include_context 'has: new form for', 'downvote', false

      context 'current_user is not set (guest)' do
        include_context 'shows upvote button', :grey
        include_context 'shows downvote button', :grey
      end

      context 'current_user is set' do
        let(:user) { FactoryBot.create(:user) }
        include_context 'login user'

        context 'user did not vote on stamp' do
          include_context 'shows upvote button', :grey
          include_context 'shows downvote button', :grey
        end

        context 'user voted on stamp' do
          context 'user upvoted' do
            before { FactoryBot.create(:upvote, votable: stamp, user: user) }

            include_context 'shows upvote button', :red
            include_context 'shows downvote button', :grey
          end

          context 'user downvoted' do
            before { FactoryBot.create(:downvote, votable: stamp, user: user) }
            include_context 'shows upvote button', :grey
            include_context 'shows downvote button', :green
          end
        end
      end
    end

    context 'state is :archived' do
      let(:state) { :archived }

      include_context 'has: new form for', 'upvote', false
      include_context 'has: new form for', 'downvote', false

      context 'current_user is not set (guest)' do
        include_context 'shows upvote button', :grey
        include_context 'shows downvote button', :grey
      end

      context 'current_user is set' do
        let(:user) { FactoryBot.create(:user) }
        include_context 'login user'

        context 'user did not vote on stamp' do
          include_context 'shows upvote button', :grey
          include_context 'shows downvote button', :grey
        end

        context 'user voted on stamp' do
          context 'user upvoted' do
            before { FactoryBot.create(:upvote, votable: stamp, user: user) }

            include_context 'shows upvote button', :purple
            include_context 'shows downvote button', :grey
          end

          context 'user downvoted' do
            before { FactoryBot.create(:downvote, votable: stamp, user: user) }
            include_context 'shows upvote button', :grey
            include_context 'shows downvote button', :purple
          end
        end
      end
    end

    context 'state is :disputed' do
      let(:state) { :disputed }

      include_context 'has: new form for', 'upvote', false
      include_context 'has: new form for', 'downvote', false

      context 'current_user is not set (guest)' do
        include_context 'shows upvote button', :grey
        include_context 'shows downvote button', :grey
      end

      context 'current_user is set' do
        let(:user) { FactoryBot.create(:user) }
        include_context 'login user'

        context 'user did not vote on stamp' do
          include_context 'shows upvote button', :grey
          include_context 'shows downvote button', :grey
        end

        context 'user voted on stamp' do
          context 'user upvoted' do
            before { FactoryBot.create(:upvote, votable: stamp, user: user) }

            include_context 'shows upvote button', :purple
            include_context 'shows downvote button', :grey
          end

          context 'user downvoted' do
            before { FactoryBot.create(:downvote, votable: stamp, user: user) }
            include_context 'shows upvote button', :grey
            include_context 'shows downvote button', :purple
          end
        end
      end
    end
  end

  describe '-- right column --' do
    shared_examples 'show: other stamps segment' do |show|
      if show
        it 'shows the other stamps of this domain' do
          expect(rendered).to have_content('Other Stamps of this domain')
        end
      else
        it 'does not show other stamps of this domain' do
          expect(rendered).not_to have_content('Other Stamps of this domain')
        end
      end
    end

    shared_examples 'show: in_progress stamps segment' do |show|
      if show
        it 'shows the in_progress stamps' do
          expect(rendered).to have_content('Suggested')
        end
      else
        it 'does not show any in_progress stamps' do
          expect(rendered).not_to have_content('Suggested')
        end
      end
    end

    context 'stamped domain has sibling stamps' do
      before { stamp.domain.stamps << FactoryBot.build_list(:label_stamp, 2, state: state) }

      context 'which are accepted' do
        let(:state) { :accepted }

        include_context 'show: other stamps segment', true
        include_context 'show: in_progress stamps segment', false
      end

      context 'which are in_progress' do
        let(:state) { :in_progress }

        include_context 'show: other stamps segment', false
        include_context 'show: in_progress stamps segment', true
      end

      context 'which are both accepted and in_progress' do
        let(:state) { :in_progress }
        before { stamp.domain.stamps << FactoryBot.build_list(:label_stamp, 2, state: :accepted) }

        include_context 'show: other stamps segment', true
        include_context 'show: in_progress stamps segment', true
      end
    end

    context 'stamped domain has no sibling stamps' do
      include_context 'show: other stamps segment', false
      include_context 'show: in_progress stamps segment', false
    end

    context 'current_user is not set (guest)' do
      it 'does not link to sibling-stamp#new' do
        expect(rendered).not_to have_button('Add Stamp')
      end
    end

    context 'current_user is set' do
      include_context 'login user'

      it 'links to sibling-stamp#new' do
        expect(rendered).to have_button('Add Stamp')
      end
    end
  end
end
