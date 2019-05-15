class Stamp::Flag < Stamp
  include GroupValidator

  jsonb_accessor :data, (::ENVProxy.required_array('FLAGS', hashes: true)
                                   .each_with_object({}) do |f, h|
                                     h[f['name']] = [:boolean, default: false]
                                   end)

  validates :stampable_type, inclusion: { in: ['App'] }

  def app
    stampable
  end

  def stampable_name
    app.name
  end

  def siblings
    peers
  end

  class << self
    def flag_hashes
      ::ENVProxy.required_array('FLAGS', hashes: true)
    end

    def groups
      @groups ||= flag_hashes.select { |f| f['group'].present? }
                             .group_by { |f| f['group'] }
                             .each { |_, v| v.map! { |f| f['name'] } }
                             .map { |_, v| v }
    end
  end
end
