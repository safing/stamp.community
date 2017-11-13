module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User'
    belongs_to :stampable, polymorphic: true
    has_many :votes, as: :votable
  end
end
