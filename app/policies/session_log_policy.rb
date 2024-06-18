class SessionLogPolicy < ApplicationPolicy
  def create?
    return true
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    if user.has_role?(:facilitator, :any) then return true end  
    return false
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:vicar) then return true end  
    if user.has_role?(:facilitator, record.cohort.provider) then return true end  
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:facilitator, record.cohort.provider) then return true end 
    return false
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:facilitator, record.cohort.provider) then return true end 
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician) or user.has_role?(:state_coordinator) or user.has_role?(:vicar)
        scope.where("cohort_id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? Cohort.where(provider_id: user.filters.pluck(:provider_id)).pluck(:id) : [ -1 ])
      else
        scope.where("cohort_id in (?) AND cohort_id NOT in (?)", 
          [ 
            (Provider.with_role(:site_admin, user).length > 0 ? Provider.with_role(:site_admin, user).map{|i| i.cohort_ids} : [ ]),
            (Provider.with_role(:facilitator, user).length > 0 ? Provider.with_role(:facilitator, user).map{|i| i.cohort_ids} : [ ])
          ].flatten.uniq, 
          (user.filters.pluck(:provider_id).length > 0 ? Cohort.where(provider_id: user.filters.pluck(:provider_id)).pluck(:id) : [ -1 ])
        )
      end 
    end
  end
end
