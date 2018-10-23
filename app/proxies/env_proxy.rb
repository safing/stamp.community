module ENVProxy
  module_function

  def all
    ENV
  end

  def required(key)
    ENV[key] || (raise "Missing environment variable #{key}")
  end

  def optional(key)
    ENV[key] || nil
  end

  def required_array(key, hashes: false)
    if hashes
      JSON.parse(
        required(key).tr("'", '"')
                     .gsub('=>', ':')
                     .prepend('[')
                     .concat(']')
      )
    else
      (required(key) || '').split(',').map(&:strip)
    end
  end

  def optional_array(key, hashes: false)
    if hashes
      JSON.parse(
        (optional(key) || '').tr("'", '"')
                             .gsub('=>', ':')
                             .prepend('[')
                             .concat(']')
      )
    else
      (optional(key) || '').split(',').map(&:strip)
    end
  end

  def required_integer(key)
    required(key).to_i
  end

  def optional_integer(key)
    optional(key).to_i
  end
end
