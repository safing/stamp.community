RSpec.describe 'stamps/show.html.haml', type: :view do
  let(:stamp) { FactoryBot.build(:stamp) }

  before do
    assign(:stamp, stamp)
    render
  end

  shared_examples 'show: state' do |state|
    it "shows the state :#{state}" do
      expect(rendered).to have_content(state.titleize)
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

  it 'links to the stamped domain' do
    expect(rendered).to have_link(stamp.domain.name)
  end

  it 'shows the stamps label' do
    expect(rendered).to have_css('.container .ui.basic.segment:first', text: stamp.label.name)
  end

  it 'shows the stamps percentage' do
    expect(rendered).to have_css('.ui.basic.segment:first .ui.progress', text: stamp.percentage)
  end

  it 'shows: comments section' do
    expect(rendered).not_to have_content('Comments')
  end

  context 'stamp is in_progress' do
    include_context 'show: state', 'in_progress'

    it 'does not show any results' do
      expect(rendered).not_to have_content('Results')
    end

    context 'current_user is not set (guest)' do
      it 'does not show the \'Add Comment\' button' do
        expect(rendered).not_to have_button('Add Comment')
      end
    end

    context 'current_user is set' do
      it 'shows: \'Add Comment\' button' do
        expect(rendered).to have_button('Add Comment')
      end
    end
  end

  context 'stamp is accepted' do
    include_context 'show: state', 'accepted'
    it_behaves_like 'stamp with results'
  end

  context 'stamp is denied' do
    include_context 'show: state', 'denied'
    it_behaves_like 'stamp with results'
  end

  context 'stamp is disputed' do
    include_context 'show: state', 'disputed'
    it_behaves_like 'stamp with results'
  end

  context 'stamp is archived' do
    include_context 'show: state', 'archived'
    it_behaves_like 'stamp with results'

    it 'links to the currently accepted stamp'
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
      before { stamp.domain.stamps << FactoryBot.build_list(:stamp, 2, state: state) }

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
        before { stamp.domain.stamps << FactoryBot.build_list(:stamp, 2, state: :accepted) }

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
      it 'links to sibling-stamp#new' do
        expect(rendered).to have_button('Add stamp')
      end
    end
  end
end
