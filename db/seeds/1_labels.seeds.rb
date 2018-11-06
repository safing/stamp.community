def import_label(label_hash)
  labels = Label.where(label_hash.except(:children, :config).merge(licence_id: Licence.first.id))

  if label_hash[:config].present?
    labels = labels.config_where(label_hash[:config])
  end

  if labels.blank?
    l = Label.create(label_hash.except(:children).merge(licence_id: Licence.first.id))
  else
    l = labels.first
  end

  return l
end

labels = [
  {
    name: 'Trackers',
    description: 'Trackers',
    children: [
      {name: 'Analytics', description: 'Analytics', config: {binary: true}},
      {name: 'Ads', description: 'Ads', config: {binary: true}},
      {name: 'Other', description: 'Other', config: {binary: true}}
    ]
  },
  {
    name: 'Malware',
    description: 'Malware',
    children: [
      {name: 'CNC Server', description: 'CNC Server', config: {binary: true}},
      {name: 'Exploit', description: 'Exploit', config: {binary: true}},
      {name: 'Payload', description: 'Payload', config: {binary: true}},
      {name: 'Other', description: 'Other', config: {binary: true}}
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
