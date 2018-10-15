RSpec.describe 'domains/show.html.haml', type: :view do
  let(:domain) { FactoryBot.create(:domain) }

  def rendered
    assign(:domain, domain)
    render
    super
  end

  shared_examples 'show: accepted stamps segment' do |show|
    if show
      it 'shows the accepted stamps' do
        expect(rendered).to have_content('Accepted')
      end
    else
      it 'does not show the accepted stamps' do
        expect(rendered).not_to have_content('Accepted')
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

  it 'links to the domain' do
    expect(rendered).to have_content(domain.name)
    expect(rendered).to have_link(href: domain.href)
  end

  context 'domain has stamps' do
    before { domain.stamps << FactoryBot.build_list(:stamp, 2, state: state) }

    context 'domain has accepted stamps' do
      let(:state) { :accepted }

      include_context 'show: accepted stamps segment', true
      include_context 'show: in_progress stamps segment', false
    end

    context 'domain has in_progress stamps' do
      let(:state) { :in_progress }

      include_context 'show: accepted stamps segment', false
      include_context 'show: in_progress stamps segment', true
    end

    context 'domain has both accepted and in_progress stamps' do
      let(:state) { :in_progress }
      before { domain.stamps << FactoryBot.build_list(:stamp, 2, state: :accepted) }

      include_context 'show: accepted stamps segment', true
      include_context 'show: in_progress stamps segment', true
    end
  end

  context 'domain has no stamps' do
    include_context 'show: accepted stamps segment', false
    include_context 'show: in_progress stamps segment', false
  end

  it 'links to the user' do
    expect(rendered).to have_link(domain.user.username, href: user_path(domain.user))
  end

  context 'domain has subdomains' do
    before { domain.children << FactoryBot.build_list(:domain, 2) }

    it 'shows the subdomains' do
      expect(rendered).to have_content('Subdomains')
    end

    it 'links to the subdomains' do
      domain.children.each do |subdomain|
        expect(rendered).to have_link(subdomain.name, href: domain_path(subdomain.name))
      end
    end
  end

  context 'domain has no subdomains' do
    it 'does not show any subdomains' do
      expect(rendered).not_to have_content('Subdomains')
    end
  end

  context 'domain has a parent domain' do
    before { domain.update(parent: FactoryBot.create(:domain)) }

    it 'show: the parent domain' do
      expect(rendered).to have_content('Main Domain')
    end

    it 'links to the parent domain' do
      expect(rendered).to have_link(domain.parent.name, href: domain_path(domain.parent.name))
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
      expect(rendered).to have_link('Add Stamp', href: new_stamp_path(domain_name: domain.name))
    end
  end

  context 'guest' do
    it 'does not show a link to add a new stamp' do
      expect(rendered).not_to have_link('Add Stamp', href: new_stamp_path(domain_name: domain.name))
    end
  end
end
