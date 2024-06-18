class EnrollmentSessionLogPolicy < ApplicationPolicy
  def create?
    return true
  end
  def new?
    return true
  end
  def index?
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
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    return false
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician) or user.has_role?(:vicar)
        scope.all
      else
        if user.has_role?(:state_coordinator) 
          if !user.has_role?(:site_admin, :any) and !user.has_role?(:facilitator, :any)
            scope.where(trashed: false, cohort_id: Cohort.where(provider_id: Provider.where(is_test: false).pluck(:id)))
          else
            scope.where(trashed: false, cohort_id: Cohort.where(provider_id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq))
          end
        else
          scope.where(trashed: false, cohort_id: Cohort.where(provider_id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq))
        end
      end 
    end
  end
end
