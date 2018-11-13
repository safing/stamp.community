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
end
