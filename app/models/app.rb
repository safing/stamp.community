class App < ApplicationRecord
  # needed to load uuid that is generated by postgres
  # https://github.com/rails/rails/issues/21627#issuecomment-142625429
  # https://www.devmynd.com/blog/db-generated-values-and-activerecord/
  after_create :reload

  belongs_to :user
end