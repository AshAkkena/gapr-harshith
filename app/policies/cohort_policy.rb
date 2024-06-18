class CohortPolicy < ApplicationPolicy
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
    if user.has_role?(:vicar) then return true end
    if user.has_role?(:site_admin, :any) then return true end  
    if user.has_role?(:facilitator, :any) then return true end  
    return false
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
    if user.has_role?(:site_admin, :any) then return true end  
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
        scope.where("provider_id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ]).order(:period, :provider_id, :name, :extra_name)
      else
        if user.has_role?(:state_coordinator) 
          if !user.has_role?(:site_admin, :any) and !user.has_role?(:facilitator, :any)
            scope.where(provider_id: Provider.where(is_test: false).pluck(:id)).where("provider_id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ]).order(:period, :provider_id, :name, :extra_name)
          else
            scope.where(provider_id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).where("provider_id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ]).order(:period, :provider_id, :name, :extra_name)
          end
        else
          scope.where(provider_id: (Provider.with_role(:facilitator, user).pluck(:id) + Provider.with_role(:site_admin, user).pluck(:id)).uniq).where("provider_id NOT in (?)", user.filters.pluck(:provider_id).length > 0 ? user.filters.pluck(:provider_id) : [ -1 ]).order(:period, :provider_id, :name, :extra_name)
        end
      end 
    end
  end
end
