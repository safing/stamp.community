# create stamps for all labels
begin
  tryhard = false

  Label.all.each_with_index do |label, i|
    unless tryhard
      FactoryBot.create_list(:stamp, 3, label: label)

      puts "#{i}: @#{label.name}"
    end

    if tryhard || i >= 5
      FactoryBot.create_list(:stamp, 3, label: label, stampable: Domain.order('RANDOM()').first, creator: User.first)
    end
  end
rescue
  tryhard = true
end
