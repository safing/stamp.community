RSpec.describe 'domains/show.html.haml', type: :view do
  let(:domain) { FactoryBot.build(:domain) }

  before do
    assign(:domain, domain)
    render
  end

  context 'domain has stamps' do
    before { domain.stamps << FactoryBot.build_list(:stamp, 2, state: state) }

    context 'domain has accepted stamps' do
      let(:state) { :accepted }

      it 'shows the accepted stamps' do
        expect(rendered).to have_content('Accepted')
      end
      it 'does not show any in_progress stamps' do
        expect(rendered).not_to have_content('Suggested')
      end
    end

    context 'domain has in_progress stamps' do
      let(:state) { :in_progress }

      it 'does not show any accepted stamps' do
        expect(rendered).not_to have_content('Accepted')
      end

      it 'shows the in_progress stamps' do
        expect(rendered).to have_content('Suggested')
      end
    end

    context 'domain has both accepted and in_progress stamps' do
      let(:state) { :in_progress }
      before { domain.stamps << FactoryBot.build_list(:stamp, 2, state: :accepted) }

      it 'shows the accepted stamps' do
        expect(rendered).to have_content('Accepted')
      end

      it 'shows the in_progress stamps' do
        expect(rendered).to have_content('Suggested')
      end
    end
  end

  context 'domain has no stamps' do
    it 'does not show any accepted stamps' do
      expect(rendered).not_to have_content('Accepted')
    end

    it 'does not show any in_progress stamps' do
      expect(rendered).not_to have_content('Suggested')
    end
  end

  it 'links to the creator' do
    expect(rendered).to have_link(domain.creator.username, href: user_path(domain.creator))
  end

  context 'domain has subdomains' do
    before { domain.children << FactoryBot.build_list(:domain, 2) }

    it 'shows the subdomains' do
      expect(rendered).to have_content('Subdomains')
    end
  end

  context 'domain has no subdomains' do
    it 'does not show any subdomains' do
      expect(rendered).not_to have_content('Subdomains')
    end
  end

  context 'domain has a parent domain' do
    before { domain.update(parent: FactoryBot.create(:domain)) }

    it 'show the parent domain' do
      expect(rendered).to have_content('Main Domain')
    end
  end

  context 'domain has no parent' do
    it 'does not show the parent domain' do
      expect(rendered).not_to have_content('Main Domain')
    end
  end

  context 'user is signed in' do
    include_context 'login user'

    it 'shows a link to add a new stamp' do
      expect(rendered).to have_link('Add Stamp', href: new_stamp_path)
    end
  end

  context 'guest' do
    it 'does not show a link to add a new stamp' do
      expect(rendered).not_to have_link('Add Stamp', href: new_stamp_path)
    end
  end
end
