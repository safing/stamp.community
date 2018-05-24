module Votable
  module State
    extend ActiveSupport::Concern

    included do
      scope :accepted, -> { with_state(:accepted) }
      scope :archived, -> { with_state(:archived) }
      scope :denied, -> { with_state(:denied) }
      scope :in_progress, -> { with_state(:in_progress) }
      scope :overruled, -> { with_state(:overruled) }

      state_machine initial: :in_progress do
        transition in_progress: :accepted, on: :accept
        transition in_progress: :denied, on: :deny
        transition accepted: :archived, on: :archive
        # admins / mods can overrule stamps
        transition %i[accepted denied] => :overruled, on: :overrule
      end
    end
  end
end
