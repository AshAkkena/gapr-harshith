class EntrySurveyPolicy < ApplicationPolicy
  def create?
    return true
  end

  def new?
    return true
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if user.has_role?(:technician) then return true end
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
      if user
        if user.has_role?(:technician)
          scope.all.order(:created_at)
        else
          scope.none
	end 
      else
        scope.none
      end
    end
  end
end
