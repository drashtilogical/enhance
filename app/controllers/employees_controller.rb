class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  # GET /employees or /employees.json
  def index
    @employees = Employee.includes(:projects, :assignments).page(params[:page]).per(10)
  end

  # GET /employees/1 or /employees/1.json
  def show; end

  def history
    @employees = Employee.includes(:projects)
    if params[:project_id].present?
      @employees = @employees.where(projects: { id: params[:project_id] })
    end
    @employees = @employees.page(params[:page]).per(5)
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit; end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: 'Employee was successfully created.' }
        format.json { render :index, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employees_path, notice: 'Employee was successfully updated.' }
        format.json { render :index, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign_projects
    employees = Employee.includes(:assignments)
    projects = Project.includes(:assignments)
    a = []
    employee_workloads = employees.map { |employee| { employee_id: employee.id, emp_count: employee.assignments.count } }
    sorted_workloads = employee_workloads.sort_by { |data| data[:emp_count] }

    selected_employees = sorted_workloads.take(projects.length).map { |data| data[:employee_id] }

    selected_employees.each do |employee_id|
      employee = employees.find(employee_id)
      available_projects = projects.reject { |project| employee.assignments.exists?(project_id: project.id) }
      break if available_projects.empty?

      available_project_ids = available_projects.pluck(:id) - Assignment.where(employee_id: employee_id).pluck(:project_id)
      project_id = available_project_ids.sample
      while a.include?(project_id)
        project_id = available_project_ids.sample
      end
      a << project_id
      Assignment.create(employee: employee, project_id: project_id)
    end

    redirect_to employees_path, notice: 'Projects assigned successfully.'
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :age)
  end
end
