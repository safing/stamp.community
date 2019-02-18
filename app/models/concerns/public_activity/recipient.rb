module PublicActivity
  module Recipient
    extend ActiveSupport::Concern

    included do
      has_many :activities_as_recipient, class_name: 'PublicActivity::Activity', as: :recipient
    end
  end
end
