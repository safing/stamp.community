# Used for system activites. It basically enables PublicActivity to create a system activity
# so instead of: {owner_type: User, owner_id: 5}
# it creates: {owner_type: System, owner_id: -1}
# enables: System.new.activities
# => returns all system activities
class System < User
  def id
    @id ||= -1
  end

  def activities
    PublicActivity::Activity.where(owner_type: 'System', owner_id: id)
  end
end
