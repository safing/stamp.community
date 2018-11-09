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

  def siblings
    peers
  end

  def internet?
    internet
  end

  def lan?
    lan || internet?
  end

  def localhost?
    localhost || lan?
  end

  def none?
    none || localhost?
  end

  class << self
    # https://stackoverflow.com/a/9463495/2235594
    # might override stuff, a better approach might be:
    # https://gist.github.com/sj26/5843855
    def model_name
      base_class.model_name
    end

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
