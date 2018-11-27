class LicencesController < ApplicationController
  def show
    @licence = Licence.find(params[:id])
  end
  def index
    @licences = Licence.all
  end
end
