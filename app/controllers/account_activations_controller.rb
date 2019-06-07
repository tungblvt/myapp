class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user&.!activated?&.authenticated?(:activation, params[:id])
      user.update activated: true, activated_at: Time.zone.now
      user.activate
      log_in user
      flash[:success] = t "account_activated"
      redirect_to user
    else
      flash[:danger] = t "invalid_activation_link"
      redirect_to root_url
    end
  end
end
