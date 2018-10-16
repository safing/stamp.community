class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, length: { minimum: 40 }
  validates_presence_of %i[commentable content user]
end
