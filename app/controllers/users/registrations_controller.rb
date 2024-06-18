# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  #prepend_before_action :check_captcha, only: [:create]
  if Rails.env.development?
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      flash.delete :recaptcha_error
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end
#  private
#  
#  def check_captcha
#    return if !verify_recaptcha # verify_recaptcha(action: 'signup') for v3
#
#    self.resource = resource_class.new sign_up_params
#    resource.validate # Look for any other validation errors besides reCAPTCHA
#    set_minimum_password_length
#
#    respond_with_navigational(resource) do
#      flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
#      render :new
#    end
#  end
#  protected


  # If you have extra params to permit, append them to the sanitizer.
#  def configure_sign_up_params
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
   # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
