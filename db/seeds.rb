# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first,

labels = ["Adult Themes", "Advertising", "Alcohol", "Anime/Manga/Webcomic", "Auctions", "Automotive", "Blogs", "Business Services", "Chat", "Classifieds", "Dating", "Drugs", "Ecommerce/Shopping", "Educational Institutions", "File Storage", "Financial Institutions", "Forums/Message", "Gambling", "Games", "Government", "Hate/Discrimination", "Health and Fitness", "Humor", "Instant Messaging", "Jobs/Employment", "Lingerie/Bikini", "Movies", "Music", "News/Media", "Non-Profits", "Nudity", "P2P/File", "Parked Domains", "Photo Sharing", "Podcasts", "Politics", "Pornography", "Portals", "Proxy/Anonymizer", "Radio", "Religious", "Research/Reference", "Search Engines", "Sexuality", "Social Networking", "Software/Technology", "Sports Martial Arts", "Tasteless Pro-Suicide", "Television", "Tobacco", "Travel", "URL Shortener", "Video Sharing", "Visual Search Engines", "Weapons", "Web Spam", "Webmail", "No JS Support"]

domain = FactoryBot.create(:domain)

['assets', 'login', 'blog', 'forum'].each do |subdomain_key|
  FactoryBot.create(:domain, name: subdomain_key + '.' + domain.name, parent: domain)
end

labels.each do |name|
  label = Label.find_or_create_by(name: name)
  FactoryBot.create_list(:stamp, 3, label: label)
end

4.times do
  label = Label.find_or_create_by(name: labels.sample)
  %w[in_progress accepted denied archived overruled].each do |state|
    FactoryBot.create(:stamp, label: label, stampable: domain, creator: User.first, state: state)
  end
end

stamp = FactoryBot.create(:stamp)

20.times { FactoryBot.create(:vote, votable: stamp) }
