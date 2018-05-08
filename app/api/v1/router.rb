class V1::Router < Grape::API
  mount DomainsAPI
  mount LabelsAPI
  mount LicencesAPI
  mount StampsAPI
end
