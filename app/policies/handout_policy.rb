class HandoutPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    if user.has_role?(:facilitator, :any) then return true end  
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician)
        scope.all
      else
        scope.where(active: true)
      end 
    end
  end
end
