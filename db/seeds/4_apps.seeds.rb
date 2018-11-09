user_id = User.first.id
apps = [
  {
    name: 'Spotify',
    link: 'spotify.com',
    description: 'Music for everyone',
    linux: true,
    macos: true,
    windows: true,
    user_id: user_id
  },
  {
    name: 'Wire',
    link: 'wire.com',
    description: 'Secure messaging, file sharing, voice calls and video conferences.
                 All protected with end-to-end encryption. Open source.',
    linux: true,
    macos: true,
    windows: true,
    user_id: user_id
  },
  {
    name: 'Atom',
    link: 'atom.io',
    description: 'A hackable text editor for the 21st Century',
    linux: true,
    macos: true,
    windows: true,
    user_id: user_id
  },
  {
    name: 'iTerm2',
    link: 'iterm2.com',
    description: 'A terminal emulator for macOS that does amazing things.',
    linux: false,
    macos: true,
    windows: false,
    user_id: user_id
  }
]

apps.each { |app| App.create(app) }
