RSpec.describe 'domains/new.html.haml', type: :view do
  let(:domain) { FactoryBot.build(:domain) }

  before do
    assign(:domain, domain)
    render
  end

  it 'shows the input label' do
    expect(rendered).to have_css('input[type=text]')
  end

  it 'shows the Create Domain button' do
    expect(rendered).to have_button('Create')
  end
end
