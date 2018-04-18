class V1::Router < Grape::API
  mount LabelsAPI
  mount StampsAPI
end
