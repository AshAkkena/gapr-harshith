class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  if Rails.env.development?
    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index
  end

  before_action :set_paper_trail_whodunnit

  private

  def not_authorized
    flash[:danger] = "Insufficient authorization for requested action."
    redirect_to(request.referrer || root_path)
  end

  
end
