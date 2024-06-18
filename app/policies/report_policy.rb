class ReportPolicy < ApplicationPolicy
  def view?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end
    return false
  end
  
  def visualize?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:site_admin, :any) then return true end
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end
    return false
  end
  
  def mpr_helper?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
end
