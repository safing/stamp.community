# rubocop: disable Style/ClassAndModuleChildren
module FactoryBot::Syntax::Methods
  def attributes_with_foreign_keys_for(*args)
    FactoryBot.build(*args).attributes.delete_if do |k, _|
      %w[id type created_at updated_at].member?(k)
    end
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# rubocop: enable Style/ClassAndModuleChildren
