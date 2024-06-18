class StaffTrainingSurveyPolicy < ApplicationPolicy
  def create?
    return true
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
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician)
        scope.all
      else
        scope.none
      end 
    end
  end
end
