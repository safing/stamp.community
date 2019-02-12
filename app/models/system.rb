# Used for system activities. It basically enables PublicActivity to create a system activity
# so instead of: {owner_type: User, owner_id: 5}
# it creates: {owner_type: System, owner_id: -1}
# enables: System.new.activities
# => returns all system activities
class System < User
  after_initialize -> { self.id = -1 }

  def self.polymorphic_name
    'System'
  end
end
