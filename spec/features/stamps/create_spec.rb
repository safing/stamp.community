# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'User creates a stamp' do
  include_context 'login user'

  background do
    FactoryBot.create_list(:domain, 2)
    FactoryBot.create_list(:label, 2)
  end

  scenario 'with valid attributes' do
    visit new_stamp_path

    expect(page).to have_content('Percentage')

    page.find('#stamp_percentage').set('20')
    page.click_button 'Create'

    expect(page).to have_current_path(stamp_path(Stamp.first))

    expect(page).to have_content('In Progress')
    expect(page).to have_content('Stamp created successfully')
  end
end
