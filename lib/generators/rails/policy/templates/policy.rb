<% module_namespacing do -%>
class <%= class_name %>Policy < ApplicationPolicy
  attr_reader :user, :<%= singular_table_name %>

  def initialize(user, <%= singular_table_name %>)
    @user = user
    @<%= singular_table_name %> = <%= singular_table_name %>
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
<% end -%>
