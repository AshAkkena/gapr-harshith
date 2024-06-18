class CohoUpPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end 
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end

  def new?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end 
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
#    if user.has_role?(:state_coordinator) then return true end  
#    if user.has_role?(:site_admin, record.cohort.provider) then return true end 
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, record.cohort.provider) then return true end 
    return false
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
#    if user.has_role?(:site_admin, record.cohort.provider) then return true end 
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician)
        scope.all
      else
        #scope.all
        scope.where(cohort_id: Cohort.where(provider_id: Provider.with_role(:site_admin, user)).or(Cohort.where(provider_id: Provider.with_role(:facilitator, user))).pluck(:id))
        #.or(scope.where(provider_id: Provider.with_role(:facilitator, user).pluck(:id)))).pluck(:id)
       
      end 
    end
  end
end
