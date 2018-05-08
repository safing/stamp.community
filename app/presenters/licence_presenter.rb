module LicencePresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'Licence id',
      required: true
    }

    expose :name, documentation: {
      type: 'Integer',
      desc: 'Name',
      required: true
    }

    expose :description, documentation: {
      type: 'String',
      desc: 'Description',
      required: true
    }
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :licences, using: LicencePresenter::Entity
  end
end
