# create main_domain with subdomains and plenty of stamps
main_domain = FactoryBot.create(:domain, name: 'safing.io')

['assets', 'login', 'blog', 'forum'].each do |subdomain_key|
  FactoryBot.create(:domain, name: subdomain_key + '.' + main_domain.name, parent: main_domain)
end

Label.first(4).each do |label|
  %w[accepted archived denied disputed in_progress].each do |state|
    FactoryBot.create(:label_stamp, :binary, label_id: label.id, stampable: main_domain, creator: User.first, state: state)
  end
end

# create main_stamp with plenty of votes
main_stamp = FactoryBot.create(:label_stamp, :binary, label_id: Label.order('RANDOM()').first.id, stampable: main_domain)

23.times { FactoryBot.create(:vote, votable: main_stamp) }

puts "Main Domain is #{main_domain.name}"
puts "Main Stamp is ##{main_stamp.id}"
