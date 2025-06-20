class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects or /projects.json
  def index
    # Ransack search with task count per project
    # We're joining tasks to count them, even if a project has none (LEFT JOIN)
    @q = Project.ransack(params[:q])
    @projects = @q.result
        .left_joins(:tasks)
        .group('projects.id')
        .select('projects.*, COUNT(tasks.id) AS tasks_count')
        .page(params[:page])
        .per(10)

    order_by = params.dig(:q, :s) || 'projects.created_at desc'

    if order_by == 'tasks_count desc'
        @projects = @projects.reorder('COUNT(tasks.id) DESC')
    elsif order_by == 'tasks_count asc'
        @projects = @projects.reorder('COUNT(tasks.id) ASC')
    else
        @projects = @projects.reorder(order_by)
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    @tasks = @project.tasks.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project was successfully destroyed"
    else
      redirect_to @project, alert: @project.errors.full_messages.to_sentence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
