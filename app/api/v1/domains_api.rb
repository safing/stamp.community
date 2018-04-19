class V1::DomainsAPI < Grape::API
  namespace :domains, requirements: { name: Domain::NAME_REGEX } do
    route_param :name do
      get do
        present Domain.find_by!(name: params[:name]), with: DomainPresenter::Entity
      end

      get :stamps do
        name = params[:name]

        present Domain.find_by!(name: name), with: DomainPresenter::Entity, with_stamps: true
      end
    end
  end
end
