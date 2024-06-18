class ProviderPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  def aggregate?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end
    return false
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, record) then return true end  
    return false
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, record) then return true end
    return false
  end
  
  def finalize?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
    return false
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end


  class Scope < Scope
    def resolve
      if user.has_role?(:technician) or user.has_role?(:vicar)
        scope.all.where("id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ])
      else
        if user.has_role?(:state_coordinator) 
          if !user.has_role?(:site_admin, :any) and !user.has_role?(:facilitator, :any)
            scope.where(id: Provider.where(is_test: false).pluck(:id)).where("id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ])
          else
            scope.where(id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).where("id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ])
          end
        else
          scope.where(id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).where("id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ])
        end
      end 
    end
    def filter_check 
      if user.has_role?(:technician) or user.has_role?(:vicar)
        scope.all.order(:period, :pmms_aggregate_name, :long_name)
      else
        if user.has_role?(:state_coordinator) 
          if !user.has_role?(:site_admin, :any) and !user.has_role?(:facilitator, :any)
            scope.where(id: Provider.where(is_test: false).pluck(:id)).order(:period, :pmms_aggregate_name, :long_name)
          else
            scope.where(id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).order(:period, :pmms_aggregate_name, :long_name)
          end
        else
          scope.where(id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).order(:period, :pmms_aggregate_name, :long_name)
        end
      end 
    end  
  end
end
