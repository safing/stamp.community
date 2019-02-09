module PublicActivity
  module Owner
    extend ActiveSupport::Concern

    included do
      has_many :activities_as_owner, class_name: 'PublicActivity::Activity', as: :owner
    end
  end
end
