module Votable
  module State
    extend ActiveSupport::Concern

    included do
      scope :accepted, -> { with_state(:accepted) }
      scope :archived, -> { with_state(:archived) }
      scope :denied, -> { with_state(:denied) }
      scope :in_progress, -> { with_state(:in_progress) }
      scope :overruled, -> { with_state(:overruled) }

      state_machine initial: :in_progress, use_transactions: true do
        transition in_progress: :accepted, on: :accept
        transition in_progress: :denied, on: :deny
        transition accepted: :archived, on: :archive
        # admins / mods can overrule stamps
        transition %i[accepted denied] => :overruled, on: :overrule

        before_transition in_progress: :accepted do |votable, _|
          votable.archive_accepted_siblings!
        end
      end

      def archive_accepted_siblings!
        accepted_instance = stampable.send(self.class.name.parameterize.pluralize)
                                     .where(label: label)
                                     .accepted
        accepted_instance.each(&:archive!) if accepted_instance.exists?
      end
    end
  end
end
