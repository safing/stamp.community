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

  def required_array(key)
    (required(key) || '').split(',').map(&:strip)
  end

  def optional_array(key)
    (optional(key) || '').split(',').map(&:strip)
  end

  def required_integer(key)
    required(key).to_i
  end

  def optional_integer(key)
    optional(key).to_i
  end
end
