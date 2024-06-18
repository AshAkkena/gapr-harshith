class FiltersController < ApplicationController
  before_action :set_filter, only: %i[ remove ]

  # GET /filters or /filters.json
  def index
    authorize Filter, :index?
    @filters = policy_scope(Filter).order(:user_id)
    @providers = ProviderPolicy::Scope.new(current_user, Provider).filter_check.order(:pmms_aggregate_name, :long_name)
  end

  def add
    authorize Filter, :create?
    if policy_scope(Provider).where(id: params[:provider_id])
      else
        flash[:danger] = 'Provider not in scope.'
        redirect_to filters_path
        return
    end
    @filter = Filter.new(user_id: current_user.id, provider_id: params[:provider_id])
    if @filter.save
        flash[:success] = 'Filter altered.'
        redirect_to filters_path
        return    
    else
    end
  end
  
  def remove
    authorize @filter, :destroy?
    if @filter.destroy
      flash[:success] = 'Filter altered.'
      redirect_to filters_path
      return    
    else
      flash[:danger] = 'Something went wrong.'
      redirect_to filters_path
      return    
    end
    
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find(params[:id])
    end
 
    # Only allow a list of trusted parameters through.
    def filter_params
      params.require(:filter).permit(:user_id, :provider_id)
    end
end
