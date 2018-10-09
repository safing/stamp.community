def import_label(label_hash)
  Label.find_or_create_by(label_hash.except(:children).merge(licence_id: Licence.first.id))
end

labels = [
  {
    name: 'Trackers',
    description: 'Trackers',
    children: [
      {name: 'Analytics', description: 'Analytics'},
      {name: 'Ads', description: 'Ads'},
      {name: 'Other', description: 'Other'}
    ]
  },
  {
    name: 'Malware',
    description: 'Malware',
    children: [
      {name: 'CNC Server', description: 'CNC Server'},
      {name: 'Exploit', description: 'Exploit'},
      {name: 'Payload', description: 'Payload'},
      {name: 'Other', description: 'Other'}
    ]
  },
]

labels.each_with_index do |label_hash|
  parent_label = import_label(label_hash)

  if label_hash[:children].present?
    label_hash[:children].each do |child_hash|
      import_label(child_hash.merge(parent_id: parent_label.id))
    end
  end
end
