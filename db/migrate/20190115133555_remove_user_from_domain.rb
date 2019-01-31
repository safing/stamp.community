class RemoveUserFromDomain < ActiveRecord::Migration[5.2]
  def up
    Domain.all.each do |domain|
      domain.create_activity(
        :create,
        owner: User.find(domain.user_id),
        created_at: domain.created_at,
        updated_at: domain.created_at
      )
    end
    remove_column :domains, :user_id
  end

  # ONE WAY STREET - did not see the use in adding the complex down query
end
