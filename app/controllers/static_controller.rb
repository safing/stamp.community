class StaticController < ApplicationController
  skip_after_action :verify_authorized

  def terms
  end
end
