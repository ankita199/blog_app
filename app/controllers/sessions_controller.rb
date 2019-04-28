class SessionsController < ApplicationController

  def new
    render_bs_modal("login","login")
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.activated?
        log_in user
        params[:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user_path(user.id)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render_bs_modal("login","login")
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
