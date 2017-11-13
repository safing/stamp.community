class Stamp < ApplicationRecord
  module State
    extend ActiveSupport::Concern

    included do
      state_machine :initial => :in_progress do
        transition :in_progress => :accepted, on: :accept
        transition :in_progress => :denied, on: :deny
        transition [:accepted, :denied] => :archived, on: :archive
        transition [:accepted, :denied] => :overruled, on: :overruleT
      end
    end
  end
end
