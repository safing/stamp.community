module PublicActivity
  module CommonWithSystem
    # WARNING: when updating PublicActivity assert this still works!

    extend ActiveSupport::Concern

    included do
      include PublicActivity::Common

      def create_system_activity(*args)
        @system_activity = true
        create_activity(*args)
      end

      private

      # called by #create_activity
      # github.com/chaps-io/public_activity/blob/1-6-stable/lib/public_activity/common.rb#L252
      # we set or overwrite the settings with our fixed #system_options
      # this way we assure an Activity with owner_id: -1 & owner_type: 'System' is created

      def prepare_settings(*args)
        if @system_activity
          # reset so a normal activity can be created by this instance
          @system_activity = nil

          super(*args).merge(system_options)
        else
          super(*args)
        end
      end

      def system_options
        {
          owner_id: -1,
          owner_type: 'System'
        }
      end

      def system_activity
        @system_activity ||= false
      end
    end
  end
end
