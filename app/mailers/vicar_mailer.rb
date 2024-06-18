class VicarMailer < ApplicationMailer
  def cohoup_notify
    @coho_up = params[:coho_up]
    mail(to: User.with_role(:technician).pluck(:email), bcc: User.with_role(:vicar).pluck(:email), subject: '[GaPR] New Cohort Activation')
  end
end
