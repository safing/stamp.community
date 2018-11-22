class SetNotNullFields < ActiveRecord::Migration[5.2]
  def change
    # api_keys
    change_column_null :api_keys, :token, false
    change_column_null :api_keys, :user_id, false

    # apps
    change_column_null :apps, :description, false, 'Take back control of your data!'
    change_column_null :apps, :link, false, 'safing.io'
    change_column_null :apps, :name, false, 'Portmaster'
    change_column_null :apps, :user_id, false

    # comments
    change_column_null :comments, :content, false

    # domains
    change_column_null :domains, :user_id, false

    # labels
    change_column_null :labels, :description, false, 'Take back control of your data!'
    change_column_null :labels, :licence_id, false
    change_column_null :labels, :name, false, 'Random Label'

    # licences
    change_column_null :licences, :description, false, 'Some legal stuff'

    # stamps
    change_column_null :stamps, :stampable_id, false
    change_column_null :stamps, :stampable_type, false, 'Domain'
    change_column_null :stamps, :state, false, 'in_progress'
    change_column_null :stamps, :user_id, false

    # users
    change_column_null :users, :role, false
  end
end
