class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @articles = Article.includes(:user).paginate(page: params[:page])
  end
  
  def new
    @user = User.new
    render_bs_modal("signup","signup")
  end
  
  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render_bs_modal("signup","signup")
    end
  end
  
  def edit
  end
  
  def update
    @user.avatar.attach(params[:user][:avatar])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    if admin_user
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
    else
      flash[:error] = "Unauthorized!."
    end
    redirect_to root_url
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
