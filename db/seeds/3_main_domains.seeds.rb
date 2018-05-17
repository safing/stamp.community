# create main_domain with subdomains and plenty of stamps
main_domain = FactoryBot.create(:domain)

['assets', 'login', 'blog', 'forum'].each do |subdomain_key|
  FactoryBot.create(:domain, name: subdomain_key + '.' + main_domain.name, parent: main_domain)
end

4.times do
  label = Label.order('RANDOM()').first
  %w[in_progress accepted denied archived overruled].each do |state|
    FactoryBot.create(:stamp, label: label, stampable: main_domain, creator: User.first, state: state)
  end
end

# create main_stamp with plenty of votes
main_stamp = FactoryBot.create(:stamp, label: Label.order('RANDOM()').first, stampable: main_domain)

23.times { FactoryBot.create(:vote, votable: main_stamp) }

puts "Main Domain is #{main_domain.name}"
puts "Main Stamp is ##{main_stamp.id}"
