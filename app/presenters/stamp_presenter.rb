module StampPresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'Stamp id',
      required: true
    }

    expose :percentage, documentation: {
      type: 'Integer',
      desc: 'Percentage (1..100)',
      required: true
    }

    expose :state, documentation: {
      type: 'String',
      desc: 'State',
      required: true
    }
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :stamps, using: StampPresenter::Entity
  end
end
