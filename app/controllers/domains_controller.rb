class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by(name: params[:name])
  end

  def new
    @domain = Domain.new
  end

  # TODO: refactor this
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def create
    @domain = Domain.new(domain_params)

    if @domain.valid?
      @domain = Domain.find_or_initialize_by(name: domain_params[:name])

      if @domain.new_record?
        # TODO: check whether domain is online or not, with ping or sth similar
        @domain.user = current_user
        @domain.save!

        @state = 'success'
        @link = domain_path(@domain.name)
        @header = 'Succesfully created.'
      else
        @state = 'warning'
        @link = domain_path(@domain.name)
        @header = 'Domain already exists.'
      end
    else
      @state = 'error'
      @header = 'Invalid Domain'
    end

    respond_to do |format|
      format.js
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def domain_params
    params.require(:domain)
          .permit(:name)
          .merge(user: current_user)
  end
end
