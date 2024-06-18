class FilterPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    return true
  end
  
  def retrieve?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    return true
  end
  
  def index?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    return true
  end
  
  def update?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    return true
  end
  
  def destroy?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    if record.user_id == user.id or user.has_role?(:technician)
      return true
    end
    return false
  end
  
  class Scope < Scope
    def resolve
      if user.has_role?(:technician) or user.has_role?(:vicar)
        scope.all
      else
        scope.where(user_id: user.id)
      end 
    end
  end
end
