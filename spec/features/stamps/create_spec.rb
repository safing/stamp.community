# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'User creates a stamp', js: true do
  include_context 'login user'

  let(:domain) { FactoryBot.create(:domain) }
  let(:invalid_comment) { 'x' * 20 }
  let(:valid_comment) { 'x' * 40 }

  background do
    FactoryBot.create_list(:label, 2)
  end

  scenario 'with valid attributes' do
    visit new_stamp_path(domain_name: domain.name)

    # select a label
    page.first("[data-action='new-stamp#selectLabel']").click
    # slide percentage range
    page.find('.thumb').drag_to(page.find('#stamp_percentage_display'))
    # insert valid comment
    page.find('#stamp_comments_attributes_0_content').set(valid_comment)
    page.click_button 'Create'

    expect(page).to have_current_path(stamp_path(Stamp.last.id))
    expect(page).to have_content('Stamp created successfully')
    expect(page).to have_content('In Progress')
    expect(page).to have_content(valid_comment)
  end

  scenario 'with invalid attributes' do
    visit new_stamp_path(domain_name: domain.name)

    # select a label
    page.first("[data-action='new-stamp#selectLabel']").click
    # slide percentage range
    page.find('.thumb').drag_to(page.find('#stamp_percentage_display'))
    # insert invalid comment
    page.find('#stamp_comments_attributes_0_content').set(invalid_comment)
    page.click_button 'Create'

    expect(page).to have_current_path(stamps_path)
    expect(page).to have_content('Comments content is too short')
  end

  scenario 'with invalid attributes, but then corrects them' do
    visit new_stamp_path(domain_name: domain.name)

    # select a label
    page.first("[data-action='new-stamp#selectLabel']").click
    # slide percentage range
    page.find('.thumb').drag_to(page.find('#stamp_percentage_display'))
    # insert invalid comment
    page.find('#stamp_comments_attributes_0_content').set(invalid_comment)
    page.click_button 'Create'

    expect(page).to have_current_path(stamps_path)
    expect(page).to have_content('Comments content is too short')

    # insert valid comment
    page.find('#stamp_comments_attributes_0_content').set(valid_comment)
    page.click_button 'Create'

    expect(page).to have_current_path(stamp_path(Stamp.last.id))
    expect(page).to have_content('Stamp created successfully')
    expect(page).to have_content('In Progress')
    expect(page).to have_content(valid_comment)
  end
end
