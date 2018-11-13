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
    description: 'Services that track and profile people online.',
    children: [
      {name: 'Analytics', description: 'Services that provide visitor analysis/profiling.', config: {binary: true}},
      {name: 'Ads', description: 'Services that serve ads and track their audiences.', config: {binary: true}},
      {name: 'Other', description: 'Services that engage in tracking and profiling in another way.', config: {binary: true}}
    ]
  },
  {
    name: 'Malware',
    description: 'Domains and Websites used in Malware Operations. This does not include social engineering (such as phishing), which will later be covered by another label.',
    children: [
      {name: 'CNC Server', description: 'Domains used by a malware command and control infrastructure.', config: {binary: true}},
      {name: 'Exploit', description: 'Websites that directly execute exploits against browsers', config: {binary: true}},
      {name: 'Payload', description: 'Domains used for second stage download/infections', config: {binary: true}},
      {name: 'Download', description: 'Websites serving infected software or files.', config: {binary: true}},
      {name: 'Other', description: 'Domains and Websites used in other malicious way. This does not include social engineering (such as phishing), which will later be covered by another label.', config: {binary: true}}
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
