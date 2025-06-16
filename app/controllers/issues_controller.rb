class IssuesController < ApplicationController
  before_action :set_project
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  def index
    @issues = @project.issues.order(created_at: :desc)
  end

  def show
  end

  def new
    @issue = @project.issues.new
  end

  def edit
    @issue = @project.issues.find(params[:id])
  end

  def create
    @issue = @project.issues.new(issue_params)
    if @issue.save
      @notification = Notification.create!(
        user: @issue.user,
        notifiable: @issue,
        read: false,
        message: "You have been assigned a new issue: #{@issue.title}"
      )
      redirect_to [@project, @issue], notice: "Issue created!"
    else
      render :new
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to [@project, @issue], notice: "Issue updated."
    else
      render :edit
    end
  end

  def destroy
    @issue.destroy
    redirect_to project_issues_path(@project), notice: "Issue deleted."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_issue
    @issue = @project.issues.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :user_id)
  end
  
end
