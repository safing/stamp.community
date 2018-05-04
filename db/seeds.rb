labels = ["Adult Themes", "Advertising", "Alcohol", "Anime/Manga/Webcomic", "Auctions", "Automotive", "Blogs", "Business Services", "Chat", "Classifieds", "Dating", "Drugs", "Ecommerce/Shopping", "Educational Institutions", "File Storage", "Financial Institutions", "Forums/Message", "Gambling", "Games", "Government", "Hate/Discrimination", "Health and Fitness", "Humor", "Instant Messaging", "Jobs/Employment", "Lingerie/Bikini", "Movies", "Music", "News/Media", "Non-Profits", "Nudity", "P2P/File", "Parked Domains", "Photo Sharing", "Podcasts", "Politics", "Pornography", "Portals", "Proxy/Anonymizer", "Radio", "Religious", "Research/Reference", "Search Engines", "Sexuality", "Social Networking", "Software/Technology", "Sports Martial Arts", "Tasteless Pro-Suicide", "Television", "Tobacco", "Travel", "URL Shortener", "Video Sharing", "Visual Search Engines", "Weapons", "Web Spam", "Webmail", "No JS Support"]

begin
  tryhard = false

  labels.each_with_index do |name, i|
    unless tryhard
      label = Label.find_or_create_by(name: name)
      FactoryBot.create_list(:stamp, 3, label: label)

      puts "#{i}: @#{name}"
    end

    if tryhard || i >= 5
      label = Label.find_or_create_by(name: name)
      FactoryBot.create_list(:stamp, 3, label: label, stampable: Domain.order('RANDOM()').first, creator: User.first)
    end
  end
rescue
  tryhard = true
end

# create main_domain with subdomains and plenty of stamps
main_domain = FactoryBot.create(:domain)

['assets', 'login', 'blog', 'forum'].each do |subdomain_key|
  FactoryBot.create(:domain, name: subdomain_key + '.' + main_domain.name, parent: main_domain)
end

4.times do
  label = Label.find_or_create_by(name: labels.sample)
  %w[in_progress accepted denied archived overruled].each do |state|
    FactoryBot.create(:stamp, label: label, stampable: main_domain, creator: User.first, state: state)
  end
end

# create main_stamp with plenty of votes
main_stamp = FactoryBot.create(:stamp, label: Label.find_or_create_by(name: labels.sample), stampable: main_domain)

23.times { FactoryBot.create(:vote, votable: main_stamp) }

puts "Main Domain is #{main_domain.name}"
puts "Main Stamp is ##{main_stamp.id}"
