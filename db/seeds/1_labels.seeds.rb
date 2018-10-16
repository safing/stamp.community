def import_label(label_hash)
  Label.find_or_create_by(label_hash.except(:children).merge(licence_id: Licence.first.id))
end

labels = [
  {
    name: 'Trackers',
    description: 'Trackers',
    children: [
      {name: 'Analytics', description: 'Analytics', config: {binary: true, steps: 100}},
      {name: 'Ads', description: 'Ads', config: {binary: true, steps: 100}},
      {name: 'Other', description: 'Other', config: {binary: true, steps: 100}}
    ]
  },
  {
    name: 'Malware',
    description: 'Malware',
    children: [
      {name: 'CNC Server', description: 'CNC Server', config: {binary: true, steps: 100}},
      {name: 'Exploit', description: 'Exploit', config: {binary: true, steps: 100}},
      {name: 'Payload', description: 'Payload', config: {binary: true, steps: 100}},
      {name: 'Other', description: 'Other', config: {binary: true, steps: 100}}
    ]
  }
]

labels.each do |label_hash|
  parent_label = import_label(label_hash)

  if label_hash[:children].present?
    label_hash[:children].each do |child_hash|
      import_label(child_hash.merge(parent_id: parent_label.id))
    end
  end
end
