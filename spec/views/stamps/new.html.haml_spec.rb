RSpec.describe 'stamps/new.html.haml', type: :view do
  let(:stamp) { FactoryBot.build(:stamp) }

  before do
    FactoryBot.create(:label)
    assign(:stamp, stamp)
    render
  end

  it 'shows the labels' do
    expect(rendered).to have_css('.container .ui.basic.segment:first', text: Label.first.name)
  end

  it 'shows a percentage slider' do
    expect(rendered).to have_css('.ui.range')
    expect(rendered).to have_css('.ui.range ~ input#stamp_range_input', visible: false)
  end

  it 'shows a comment field' do
    expect(rendered).to have_content('Comments')
  end

  it "shows a 'Create Stamp' button" do
    expect(rendered).to have_button('Create Stamp')
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

    context 'domain to be stamped has sibling stamps' do
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

    context 'domain to be stamped has no sibling stamps' do
      include_context 'show: other stamps segment', false
      include_context 'show: in_progress stamps segment', false
    end
  end
end
