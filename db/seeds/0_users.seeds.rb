%w[a b c].each do |letter|
  user = User.new(
    username: letter,
    email: "#{letter}@#{letter}.com",
    password: letter,
    password_confirmation: letter,
    role: letter == 'a' ? 'admin' : 'user'
  )
  user.skip_confirmation!
  user.save

  # create user.signup activity & boost
  activity = FactoryBot.create(:signup_activity, owner: user, trackable: user)
  FactoryBot.create(:boost, reputation: 1, user: user, cause: activity, trigger: activity)
end
