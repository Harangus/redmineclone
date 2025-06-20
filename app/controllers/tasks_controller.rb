class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    # If we're nested under a project, show only tasks for that project
    # Otherwise show all tasks
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @tasks = @project.tasks.page(params[:page]).per(10)
    else
      @tasks = Task.page(params[:page]).per(10)
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new(project_id: params[:project_id]) if params[:project_id]
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        # Notify the assigned user about the new task
        @notification = Notification.create!(
          user: @task.user,
          notifiable: @task,
          read: false,
          message: "You have been assigned a new task: #{@task.subject}"
        )
        format.html { redirect_to project_path(@task.project), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    # Save project reference before destroying the task so we can redirect properly
    project = @task.project
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to project_path(project), status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(
        :subject, :description, :status, :user_id, :project_id,
        attachments_attributes: [:id, :file, :description, :_destroy]
      )
    end

end
