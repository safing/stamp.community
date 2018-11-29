module Votable
  module State
    extend ActiveSupport::Concern

    included do
      after_create :trigger_conclude_worker

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
        siblings.accepted.each(&:archive!)
      end

      def trigger_conclude_worker
        if in_progress?
          perform_in_hours = ENVProxy.required_integer('STAMP_CONCLUDE_IN_HOURS')
          Votable::ConcludeWorker.perform_in(perform_in_hours.hours, self.class.name, id)
        end
      end
    end
  end
end
