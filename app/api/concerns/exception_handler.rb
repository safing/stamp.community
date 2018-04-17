module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from :grape_exceptions

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!(e, 404)
    end
  end
end
