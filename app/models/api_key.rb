class ApiKey < ApplicationRecord
  belongs_to :user

  validates_presence_of %i[token user]
end
