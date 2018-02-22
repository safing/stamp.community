module ENVStubsHelper
  %i[
    required
    optional
    required_array
    optional_array
    required_integer
    optional_integer
  ].each do |name|
    define_method("allow_#{name}_env") { |key| allow(ENVProxy).to receive(name).with(key) }
    define_method("expect_#{name}_env") { |key| expect(ENVProxy).to receive(name).with(key) }
  end
end

RSpec.configure do |config|
  config.include ENVStubsHelper
end
