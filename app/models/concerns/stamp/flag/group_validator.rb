class Stamp::Flag < Stamp
  module GroupValidator
    extend ActiveSupport::Concern

    included do
      validate :one_in_each_group_must_be_true
    end

    def one_in_each_group_must_be_true
      self.class.groups.each do |group|
        unless one_is_true?(group)
          group_with_values = group.each_with_object({}) { |f, h| h[f] = send(f) }
          errors.add(:group, "#{group_with_values} - *one* must be set to true")
        end
      end
    end

    def one_is_true?(flags)
      counts = flags.map { |flag| send("#{flag}?") }
                    .group_by(&:itself)
                    .transform_values(&:count)
      counts[true] == 1
    end
  end
end
