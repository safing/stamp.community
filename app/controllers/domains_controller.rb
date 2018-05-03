class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by(name: params[:name])
  end
end
