RSpec.describe 'stamps/show.html.haml', type: :view do
  let(:stamp) { FactoryBot.build(:stamp) }

  xit 'links to the stamped domain' do
    assign(:stamp, stamp)

    render

    expect(rendered).to have_link(stamp.domain.name)
  end

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

  it 'shows other stamps of this domain'
  it 'shows suggested stamps of this domain'
  it 'shows user comments'

  context 'current_user is not set (guest)' do
    it 'does not link to a sibling-stamp#new'

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

    context 'stamped domain has no other stamps (sibling-stamps)' do
      xit 'does not show siblings section' do
        assign(:stamp, stamp)
        render
        expect(rendered).not_to have_content('Siblings')
      end
    end

    context 'stamped domain has (accepted/in_progress) sibling-stamps' do
      before do
        stamp.domain.stamps << FactoryBot.build_list(:stamp, 2)
      end

      context 'siblings are only accepted' do
        xit 'shows siblings section' do
          assign(:stamp, stamp)
          render
          expect(rendered).to have_content('Siblings')
        end

        xit 'links to the sibling stamps' do
          assign(:stamp, stamp)
          render
          stamp.siblings.each do |sibling|
            expect(rendered).to have_link(href: Regexp.new(/.*#{stamp_path(sibling)}/))
          end
        end
      end

      context 'siblings are only in_progress' do
      end

      context 'siblings are both accepted & in_progress' do
      end
    end
  end
end
