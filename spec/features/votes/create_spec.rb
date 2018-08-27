# `feature` is in fact just an alias for `describe` , `background` is an alias for `before`,
# `scenario` for `it`, and `given/given!` aliases for `let/let!`, respectively.

RSpec.feature 'User votes' do
  context 'on a stamp he already voted on' do
    scenario 'less than 5 minutes ago'
    scenario 'more than 5 minutes ago'
  end

  scenario 'on a stamp he has not voted on' do
    # validation for the correct state of the stamp should be in vote model
  end
end
