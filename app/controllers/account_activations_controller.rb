class AccountActivationsController < ApplicationController
  # called when a user clicks on an activation link from their email.
  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'Account activated.'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link.'
      redirect_to root_url
    end
  end
end
