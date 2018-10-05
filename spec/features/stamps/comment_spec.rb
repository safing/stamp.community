# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'User comments on a stamp' do
  include_context 'login user'

  let(:stamp) { FactoryBot.create(:stamp) }
  let(:invalid_comment) { 'x' * 20 }
  let(:valid_comment) { 'x' * 40 }

  scenario 'with valid content' do
    visit stamp_path(stamp)

    page.find('#new_comment #comment_content').set(valid_comment)
    page.click_button 'Add Comment'

    expect(page).to have_current_path(stamp_path(stamp.id))
    expect(page).to have_content('Comment created')
    expect(page).to have_content(valid_comment)
  end

  scenario 'with invalid content' do
    visit stamp_path(stamp)

    page.find('#new_comment #comment_content').set(invalid_comment)
    page.click_button 'Add Comment'

    expect(page).to have_current_path(stamp_comments_path(stamp_id: stamp.id))
    expect(page).to have_content('Content is too short')
  end

  scenario 'with invalid content, but then corrects it' do
    visit stamp_path(stamp)

    page.find('#new_comment #comment_content').set(invalid_comment)
    page.click_button 'Add Comment'

    expect(page).to have_current_path(stamp_comments_path(stamp_id: stamp.id))
    expect(page).to have_content('Content is too short')

    # insert valid comment
    page.find('#new_comment #comment_content').set(valid_comment)
    page.click_button 'Add Comment'

    expect(page).to have_current_path(stamp_path(stamp.id))
    expect(page).to have_content('Comment created')
    expect(page).to have_content(valid_comment)
  end
end
