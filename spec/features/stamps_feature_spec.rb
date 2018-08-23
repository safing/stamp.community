# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'stamp creation' do
  include_context 'login user'

  background do
    FactoryBot.create_list(:domain, 2)
    FactoryBot.create_list(:label, 2)
  end

  scenario 'user creates a new stamp' do
    visit new_stamp_path

    expect(page).to have_content('Percentage')

    page.find('#stamp_percentage').set('20')
    page.click_button 'Create'

    expect(page).to have_content('In Progress')
  end
end
