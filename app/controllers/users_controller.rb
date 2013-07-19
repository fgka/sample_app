class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create, :show]
  before_filter :authenticate_tenant!, except: [:new, :create, :show]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :set_tenants, only: [:new, :create]

  include UsersHelper
  
  def new
    @user = User.new
  end

  def create
    user = params[:user]
    desired_tenant = user[:desired_tenant]
    set_current_tenant desired_tenant
    @user = User.new(user)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in(@user, bypass: true)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def resend_user_email
    @user = current_user.find(params[:id])
    @user.resend_confirmation_token

    respond_to do |format|
      flash[:notice] = t(:success_resend, scope: "user_management.index")
      format.html { redirect_to :action => :index }
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def set_tenants
    @tenants = Tenant.find(:all, order: 'name')
  end
end
