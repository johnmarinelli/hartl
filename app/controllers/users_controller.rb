class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @microposts = @user.microposts
                       .paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.send_activation_email
        flash[:info] = 'Check your email to activate your account.'
        format.html { redirect_to root_url }
      else
        flash[:danger] = 'There are errors.'
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'User successfully updated.'
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:danger] = 'There are errors.'
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      flash[:success] = 'User successfully deleted.'
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def following
    @title = 'Following'
    @user = User.find params[:id]
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find params[:id]
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    # before filter to set @user
    def set_user
      @user = User.find(params[:id])
    end

    # before filter to make sure request user
    # is the currently logged in user
    def correct_user
      @user = User.find params[:id]
      redirect_to(root_url) unless current_user?(@user)
    end

    # before filter to make sure current user
    # is admin
    def admin_user
      redirect_to(root_url) unless logged_in? and current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
