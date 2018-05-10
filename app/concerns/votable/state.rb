module Votable
  module State
    extend ActiveSupport::Concern

    included do
      scope :accepted, -> { where(state: 'accepted') }
      scope :archived, -> { where(state: 'archived') }
      scope :denied, -> { where(state: 'denied') }
      scope :in_progress, -> { where(state: 'in_progress') }
      scope :overruled, -> { where(state: 'overruled') }

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
