module LabelPresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'Label id',
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

    expose :parent,
           using: LabelPresenter::Entity,
           documentation: {
             type: 'Entity',
             desc: 'the parent label',
             required: false
           }

    expose :stamps, using: StampPresenter::Entity, if: :with_stamps
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :labels, using: LabelPresenter::Entity
  end
end
