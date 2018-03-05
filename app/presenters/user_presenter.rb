module UserPresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'User id',
      required: true
    }

    expose :reputation, documentation: {
      type: 'Integer',
      desc: 'Reputation',
      required: true
    }

    expose :voting_power, documentation: {
      type: 'Integer',
      desc: 'Voting Power',
      required: true
    }

    expose :username, documentation: {
      type: 'String',
      desc: 'Username',
      required: true
    }
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :users, using: UserPresenter::Entity
  end
end
