user_id = User.first.id
apps = [
  {
    name: 'Spotify',
    link: 'spotify.com',
    description: 'Music for everyone',
    linux: true,
    macos: true,
    windows: true,
    flag_stamp: {
      state: 'accepted',
      user_id: user_id,
      internet: true,
      lan: false,
      localhost: false,
      prompt: true,
      blacklist: false,
      whitelist: false,
      server: false,
      p2p: false,
    }
  },
  {
    name: 'Wire',
    link: 'wire.com',
    description: 'Secure messaging, file sharing, voice calls and video conferences.
                 All protected with end-to-end encryption. Open source.',
    linux: true,
    macos: true,
    windows: true,
    flag_stamp: {
      state: 'accepted',
      user_id: user_id,
      internet: true,
      lan: false,
      localhost: false,
      prompt: true,
      blacklist: false,
      whitelist: false,
      server: false,
      p2p: false,
    }
  },
  {
    name: 'Atom',
    link: 'atom.io',
    description: 'A hackable text editor for the 21st Century',
    linux: true,
    macos: true,
    windows: true,
    flag_stamp: {
      state: 'accepted',
      user_id: user_id,
      internet: true,
      lan: false,
      localhost: false,
      prompt: true,
      blacklist: false,
      whitelist: false,
      server: false,
      p2p: false,
    }
  },
  {
    name: 'iTerm2',
    link: 'iterm2.com',
    description: 'A terminal emulator for macOS that does amazing things.',
    linux: false,
    macos: true,
    windows: false,
    flag_stamp: {
      state: 'accepted',
      user_id: user_id,
      internet: true,
      lan: false,
      localhost: false,
      prompt: true,
      blacklist: false,
      whitelist: false,
      server: false,
      p2p: true,
    }
  }
]

apps.each do |app_params|
  app = App.find_by(name: app_params[:name]) || App.create(app_params.except(:flag_stamp))

  Stamp::Flag.create(app_params[:flag_stamp].merge(stampable: app)) if app.stamps.accepted.blank?
end
