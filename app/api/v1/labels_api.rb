class V1::LabelsAPI < Grape::API
  namespace :labels do
    get do
      present Label.all, with: LabelPresenter::Collection
    end

    route_param :id do
      get do
        present Label.find(params[:id]), with: LabelPresenter::Entity
      end
    end
  end
end
