class PagesController < ApplicationController
  if Rails.env.development?
    skip_after_action :verify_policy_scoped, only: [ :index ]
  end
  
  
  def index
    if !signed_in?
      redirect_to new_user_session_path
    end
  end

end
