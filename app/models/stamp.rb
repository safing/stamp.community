class Stamp < ApplicationRecord
  include PublicActivity::CommonWithSystem
  include PublicActivity::Recipient

  TYPES = %w[Stamp::Flag Stamp::Label Stamp::Identifier].freeze

  include Votable
  include Votable::State
  include Votable::Rewardable

  belongs_to :creator, class_name: 'User', foreign_key: :user_id
  belongs_to :stampable, polymorphic: true
  has_many :comments, as: :commentable, inverse_of: :commentable

  accepts_nested_attributes_for :comments

  validates_presence_of %i[creator stampable state type]
  validates :type, inclusion: { in: TYPES }

  # peers = stamps with the same stampable
  def peers
    stampable.stamps.where.not(id: id)
  end

  def peers?
    peers.count.positive?
  end

  # must be implemented @ each subclass
  # can describe a stronger connection than peers
  def siblings
    raise NotImplementedError
  end

  def siblings?
    siblings.count.positive?
  end

  def vote_of(user)
    @vote_of ||= votes.find_by(user_id: user.id)
  end

  def conclusion_at
    created_at + ENVProxy.required_integer('STAMP_CONCLUDE_IN_HOURS').hours
  end

  def concluded_at
    conclusion_at
  end

  def creation_activity
    activities.find_by(key: 'stamp.create', owner_id: user_id)
  end

  # overwrites https://apidock.com/rails/ActiveRecord/Inheritance/ClassMethods/sti_name
  # because otherwise the type would just be Label - we already have a model called that
  def sti_name
    to_s
  end

  def param_key(base_class: true)
    (base_class ? self.class.base_class : self.class).model_name.param_key
  end

  def key_for(base_class: true, action:)
    [param_key(base_class: base_class), action].join('.')
  end

  class << self
    # ActiveModel::Naming.model_name has provides Model helpers, such as #route_key, #param_key...
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/naming.rb
    #
    # BUT:
    # our routes are not set up like the conventional way (stamp_labels/:id)
    # but the other way around (label_stamps/:id)
    #
    # so we (only) need to overwrite ActiveModel::Name._singularize (line #211)
    # all other methods we need depend on it
    #
    # and then we call Stamp::Name.new instead of ActiveModel::Name.new
    #
    # PS: Maybe a helpful gist when problems occur: https://gist.github.com/sj26/5843855
    def model_name
      @model_name ||= Stamp::Name.new(self)
    end
  end

  class Name < ActiveModel::Name
    private

    def _singularize(string)
      super.split('_').reverse.join('_')
    end
  end
end
