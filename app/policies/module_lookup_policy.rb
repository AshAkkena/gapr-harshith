class ModuleLookupPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end

  def new?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    return false
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
    if user.has_role?(:state_coordinator) then return true end  
  end
  
  def retrieve?
    #raise Pundit::NotAuthorizedError, "must be logged in" unless user
    #if user.has_role?(:technician) then return true end
    #return false
    return true
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
      if user
        if user.has_role?(:technician)
          scope.where(period: Prep::Constants::Year).order(:abbreviated_curriculum, :delivery_sequence)
        else
          #scope.all
          scope.where(period: Prep::Constants::Year).order(:abbreviated_curriculum, :delivery_sequence)
	end 
      else
        scope.where(period: Prep::Constants::Year).order(:abbreviated_curriculum, :delivery_sequence)
      end
    end
  end
end
