class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    # Exclude current user from results, apply search filtering with Ransack
    # Join with tasks to get count of assigned tasks per user
    @q = User.where.not(id: current_user.id).ransack(params[:q])
    @users = @q.result
        .left_joins(:tasks)
        .group('users.id')
        .select('users.*, COUNT(tasks.id) AS tasks_count')
        .page(params[:page])
        .per(10)
    @current_user = current_user

    order_by = params.dig(:q, :s) || 'users.first_name desc'

    if order_by == 'tasks_count desc'
        @users = @users.reorder('COUNT(tasks.id) DESC')
    elsif order_by == 'tasks.count asc'
        @users = @users.reorder('COUNT(tasks.id) ASC')
    else 
        @users = @users.reorder(order_by)
    end
  end

  def show
    # Load all tasks and issues assigned to this user for display
    @tasks = @user.tasks.includes(:user).order(created_at: :desc)
    @issues = @user.issues.includes(:user).order(created_at: :desc)
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
    # Prevent deletion if the user has assigned tasks or issues
    # Sign out the user if they delete themselves
    user = @user
    if @user.tasks.any?
        redirect_to users_path, notice: "User has assigned tasks and cannot be deleted"
    elsif @user.issues.any?
        redirect_to users_path, notice: "User has assigned issues and cannot be deleted"
    else 
        @user.destroy
        sign_out(user) if user == current_user
        redirect_to users_path, notice: "User was deleted"
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :address, :password, :password_confirmation, :avatar)
  end
end
