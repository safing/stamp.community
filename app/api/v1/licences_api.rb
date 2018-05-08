class V1::LicencesAPI < Grape::API
  namespace :licences do
    get do
      present Licence.all, with: LicencePresenter::Collection
    end

    route_param :id do
      get do
        present Licence.find(params[:id]), with: LicencePresenter::Entity
      end

      get :labels do
        present Licence.find(params[:id]), with: LicencePresenter::Entity, with_labels: true
      end
    end
  end
end
