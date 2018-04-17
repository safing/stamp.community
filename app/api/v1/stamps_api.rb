class V1::StampsAPI < Grape::API
  namespace :stamps do
    get do
      present Stamp.all, with: StampPresenter::Collection
    end

    route_param :id do
      get do
        present Stamp.find(params[:id]), with: StampPresenter::Entity
      end
    end
  end
end
