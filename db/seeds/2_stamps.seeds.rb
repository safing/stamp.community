# create stamps for all labels
begin
  tryhard = false

  Label.all.each_with_index do |label, i|
    unless tryhard
      FactoryBot.create_list(:label_stamp, 3, :binary, label_id: label.id)

      puts "#{i}: @#{label.name}"
    end

    if tryhard || i >= 5
      FactoryBot.create_list(:label_stamp, 3, :binary, label_id: label.id, stampable: Domain.order('RANDOM()').first, creator: User.first)
    end
  end
rescue
  tryhard = true
end
