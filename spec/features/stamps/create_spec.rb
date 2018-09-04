# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'User creates a stamp' do
  include_context 'login user'

  background do
    FactoryBot.create_list(:domain, 2)
    FactoryBot.create_list(:label, 2)
  end

  scenario 'with valid attributes', js: true do
    visit new_stamp_path(domain_id: 2)

    expect(page).to have_content('Select Label')
    expect(page).to have_content('Define percentage & comment')

    # select a label
    page.first("[data-action='new-stamp#selectLabel']").click
    # slide percentage range
    page.find('.thumb').drag_to(page.find('#stamp_percentage_display'))
    # insert valid comment
    page.find('#stamp_comments_attributes_0_content').set(('x' * 40))
    page.click_button 'Create'

    expect(page).to have_current_path(stamp_path(1))
    expect(page).to have_content('Stamp created successfully')
    expect(page).to have_content('In Progress')
  end
end
