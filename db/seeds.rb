# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first,

labels = ["Adult Themes", "Advertising", "Alcohol", "Anime/Manga/Webcomic", "Auctions", "Automotive", "Blogs", "Business Services", "Chat", "Classifieds", "Dating", "Drugs", "Ecommerce/Shopping", "Educational Institutions", "File Storage", "Financial Institutions", "Forums/Message", "Gambling", "Games", "Government", "Hate/Discrimination", "Health and Fitness", "Humor", "Instant Messaging", "Jobs/Employment", "Lingerie/Bikini", "Movies", "Music", "News/Media", "Non-Profits", "Nudity", "P2P/File", "Parked Domains", "Photo Sharing", "Podcasts", "Politics", "Pornography", "Portals", "Proxy/Anonymizer", "Radio", "Religious", "Research/Reference", "Search Engines", "Sexuality", "Social Networking", "Software/Technology", "Sports Martial Arts", "Tasteless Pro-Suicide", "Television", "Tobacco", "Travel", "URL Shortener", "Video Sharing", "Visual Search Engines", "Weapons", "Web Spam", "Webmail", "No JS Support"]

labels.each do |name|
  label = Label.find_or_create_by(name: name)
  FactoryBot.create_list(:stamp, 3, label: label)
end
