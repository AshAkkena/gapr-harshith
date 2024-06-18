class IncentivePolicy < ApplicationPolicy
  def fingerprint?
    return true
  end
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
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
        scope.all.order(:created_at)
      else
        if user.has_role?(:state_coordinator) 
          if !user.has_role?(:site_admin, :any) and !user.has_role?(:facilitator, :any)
            scope.none
          else
            scope.none
            #scope.where(provider_id: Provider.with_role(:site_admin, user).pluck(:id)).or(scope.where(provider_id: Provider.with_role(:facilitator, user).pluck(:id)))
          end
        else
          scope.none
          #scope.where(provider_id: Provider.with_role(:site_admin, user).pluck(:id)).or(scope.where(provider_id: Provider.with_role(:facilitator, user).pluck(:id)))
        end
      end 
    end
  end
end
