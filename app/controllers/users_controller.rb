class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :set_user,except: [:index,:new,:create]
  before_action :correct_user,only: [:edit,:update]
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @articles = Article.includes(:user).paginate(page: params[:page])
  end
  
  def new
    @user = User.new
    render_bs_modal("signup","signup")
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #@user.send_activation_email
      #flash[:info] = "Please check your email to activate your account."
      @user.activate
      flash[:info] = "User Activated."
      redirect_to root_url
    else
      render_bs_modal("signup","signup")
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    if current_user.admin?
      @user.destroy
      flash[:success] = "User deleted!"
    else
      flash[:danger] = "Unauthorized!."
    end
    redirect_to root_url
  end
  
  private
  
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:avatar)
    end
    
    # Confirms the correct user.
    def correct_user
      unless current_user?(@user)
        flash[:danger] = "Unauthorized!."
        redirect_to(root_url)
      end
    end
end
