class DataStampsController < ApplicationController
  def show
    @stamp = Stamp::Flag.last
  end

  def new
    @stamp = Stamp::Flag.new
  end

  def create; end
end
