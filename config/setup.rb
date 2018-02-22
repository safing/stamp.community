class Setup
  class << self
    def initialize_settings
      settings = YAML.load_file('config/settings.yml')
      settings.each do |key, value|
        set_env_variable(key, value)
      end
    end

    def set_env_variable(key, value)
      if value.is_a?(Array)
        ENV[key] = value.join(',')
      elsif value.is_a?(Hash)
        value.each { |k, v| set_env_variable("#{key}_#{k}", v) }
      else
        ENV[key] = value.to_s
      end
    end
  end
end
