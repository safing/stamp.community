# custom class since it is not possible to add constant via .class_eval
class Activity
  KEYS = %w[
    app.create
    comment.create
    domain.create
    stamp.accept
    stamp.archive
    stamp.create
    stamp.deny
    stamp.dispute
    user.signup
    vote.create
  ].freeze

  # outer key: defines the key of an activity ('.' replaced with '_')
  #   => this way each key can cache different data
  # inner key: caching_key
  # inner value: method(s) to call on an activity (via send) to get the cache value
  CACHE_CONFIG = {
    app_create: {
      app_name: 'trackable.name',
      user_username: 'owner.username'
    },
    comment_create: {
      comment_content: 'trackable.content',
      user_username: 'owner.username',
      stampable_name: 'recipient.stampable_name'
    },
    domain_create: {
      domain_name: 'trackable.name',
      user_username: 'owner.username'
    },
    stamp_accept: {
      stampable_name: 'trackable.stampable_name',
      stampable_type: 'trackable.type'
    },
    stamp_archive: {
      stampable_name: 'trackable.stampable_name',
      stampable_type: 'trackable.type'
    },
    stamp_create: {
      stampable_name: 'trackable.stampable_name',
      stampable_type: 'trackable.type'
    },
    stamp_deny: {
      stampable_name: 'trackable.stampable_name',
      stampable_type: 'trackable.type'
    },
    stamp_dispute: {
      stampable_name: 'trackable.stampable_name',
      stampable_type: 'trackable.type'
    },
    user_signup: {
      user_username: 'trackable.username'
    },
    vote_create: {
      user_username: 'owner.username',
      stampable_name: 'recipient.stampable_name',
      stampable_type: 'recipient.type'
    }
  }.freeze

  def persisted?
    false
  end
end
