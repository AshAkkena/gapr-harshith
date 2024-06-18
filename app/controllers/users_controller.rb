class UsersController < ApplicationController
  before_action :set_user, only: %i[ activate deactivate ]
  if Rails.env.development?
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end

  # GET /user_providers or /user_providers.json
  def index
    authorize User, :retrieve?
    @users = policy_scope(User).order(:id)
    @providers = Provider.all.order(:period, :long_name)
  end
  
  def activate
    authorize User, :update?
    if @user.id == current_user.id
      flash[:warning] = 'You cannot alter yourself.'
      redirect_to users_path
      return
    else
      if @user.active
        flash[:warning] = 'User already active.'
        redirect_to users_path
        return
      else
        @user.active = true
        if @user.save
          flash[:success] = 'User activated'
          redirect_to users_path
          return
        else
          flash[:danger] = 'User activated'
          redirect_to users_path
          return
        end
      end
    end
  end
  
  def vicar
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if user.has_role?(:vicar)
      flash[:warning] = 'Already a vicar.'
      redirect_to users_path
      return
    end
    user.add_role :vicar
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def devicar
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if !user.has_role?(:vicar)
      flash[:warning] = 'Already not a vicar.'
      redirect_to users_path
      return
    end
    user.remove_role :vicar
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def technician
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if user.has_role?(:technician)
      flash[:warning] = 'Already a technician.'
      redirect_to users_path
      return
    end
    user.add_role :technician
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def detechnician
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if !user.has_role?(:technician)
      flash[:warning] = 'Already not a technician.'
      redirect_to users_path
      return
    end
    user.remove_role :technician
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def coordinate
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if user.has_role?(:state_coordinator)
      flash[:warning] = 'Already a coordinator.'
      redirect_to users_path
      return
    end
    user.add_role :state_coordinator
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def decoordinate
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if !user.has_role?(:state_coordinator)
      flash[:warning] = 'Already not a coordinator.'
      redirect_to users_path
      return
    end
    user.remove_role :state_coordinator
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def testify
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if user.has_role?(:test)
      flash[:warning] = 'Already a tester.'
      redirect_to users_path
      return
    end
    user.add_role :test
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def detestify
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if !user.has_role?(:test)
      flash[:warning] = 'Already not a tester.'
      redirect_to users_path
      return
    end
    user.remove_role :test
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def add_site_admin_role
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if Provider.find_by_id(params[:pid]).nil?
      flash[:danger] = 'Provider does not exist.'
      redirect_to users_path
      return
    end
    provider = Provider.find_by_id(params[:pid])
    if user.has_role?(:site_admin, provider)
      flash[:warning] = 'Role already exists.'
      redirect_to users_path
      return
    end
    user.add_role :site_admin, provider
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def del_site_admin_role
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if Provider.find_by_id(params[:pid]).nil?
      flash[:danger] = 'Provider does not exist.'
      redirect_to users_path
      return
    end
    provider = Provider.find_by_id(params[:pid])
    if !user.has_role?(:site_admin, provider)
      flash[:warning] = 'Role does not exist.'
      redirect_to users_path
      return
    end
    user.remove_role :site_admin, provider
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def add_facilitator_role
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if Provider.find_by_id(params[:pid]).nil?
      flash[:danger] = 'Provider does not exist.'
      redirect_to users_path
      return
    end
    provider = Provider.find_by_id(params[:pid])
    if user.has_role?(:facilitator, provider)
      flash[:warning] = 'Role already exists.'
      redirect_to users_path
      return
    end
    user.add_role :facilitator, provider
    flash[:success] = 'Role added.'
    redirect_to users_path
  end
  
  def del_facilitator_role
    authorize User, :update?
    if User.find_by_id(params[:id]).nil?
      flash[:danger] = 'User does not exist.'
      redirect_to users_path
      return
    end
    user = User.find_by_id(params[:id])
    if Provider.find_by_id(params[:pid]).nil?
      flash[:danger] = 'Provider does not exist.'
      redirect_to users_path
      return
    end
    provider = Provider.find_by_id(params[:pid])
    if !user.has_role?(:facilitator, provider)
      flash[:warning] = 'Role does not exist.'
      redirect_to users_path
      return
    end
    user.remove_role :facilitator, provider
    flash[:success] = 'Role removed.'
    redirect_to users_path
  end
  
  def deactivate
    authorize User, :update?
    if @user.id == current_user.id
      flash[:warning] = 'You cannot alter yourself.'
      redirect_to users_path
      return
    else
      if !@user.active
        flash[:warning] = 'User already inactive.'
        redirect_to users_path
        return
      else
        @user.active = false
        if @user.save
          flash[:success] = 'User activated'
          redirect_to users_path
          return
        else
          flash[:danger] = 'User activated'
          redirect_to users_path
          return
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
#    def user_provider_params
#      params.require(:user_provider).permit()
#    end
end
