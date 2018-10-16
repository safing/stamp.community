module Votable
  module State
    extend ActiveSupport::Concern

    included do
      scope :accepted, -> { with_state(:accepted) }
      scope :archived, -> { with_state(:archived) }
      scope :denied, -> { with_state(:denied) }
      scope :disputed, -> { with_state(:disputed) }
      scope :in_progress, -> { with_state(:in_progress) }

      state_machine initial: :in_progress, use_transactions: true do
        transition in_progress: :accepted, on: :accept
        transition in_progress: :denied, on: :deny
        # controversy: a discussion of opposing opinions
        # dispute: a failure to agree
        # for now: dispute, since we do not re-enact stamps into a second round
        transition in_progress: :disputed, on: :dispute
        transition accepted: :archived, on: :archive

        before_transition in_progress: :accepted do |votable, _|
          votable.archive_accepted_siblings!
        end
      end

      def archive_accepted_siblings!
        accepted_instance = stampable.send(self.class.superclass.name.parameterize.pluralize)
                                     .accepted
        accepted_instance.each(&:archive!) if accepted_instance.exists?
      end
    end
  end
end
