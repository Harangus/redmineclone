class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    @q = User.where.not(id: current_user.id).ransack(params[:q])
    @users = @q.result.page(params[:page]).per(10)
    @current_user = current_user
  end

  def show
    #@user = User.find(params[:id])
  end

  def edit
    #@user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User created succesfully"
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User succesfully updated"
    else
      render :edit
    end
  end

  def destroy
    user = @user 
    @user.destroy
    sign_out(user) if user == current_user
    redirect_to users_path, notice: "User was deleted"
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :address, :password, :password_confirmation, :avatar)
  end
end
