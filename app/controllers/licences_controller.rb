class LicencesController < ApplicationController
  def show
    @licence = Licence.find(params[:id])
  end
end
