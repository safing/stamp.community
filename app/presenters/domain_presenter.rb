module DomainPresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'Domain id',
      required: true
    }

    expose :name, documentation: {
      type: 'String',
      desc: 'Name',
      required: true
    }

    expose :creator_id, documentation: {
      type: 'Integer',
      desc: 'User id of creator',
      required: true
    }

    with_options(expose_nil: false) do
      expose :parent_id, documentation: {
        type: 'Integer',
        desc: 'Parent id',
        required: false
      }

      expose :parent_name, documentation: {
        type: 'String',
        desc: 'Parent domain name',
        required: false
      }
    end
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :domains, using: DomainPresenter::Entity
  end
end
