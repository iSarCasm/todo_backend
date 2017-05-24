module V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, except: [:create]

    def create
      @task = get_project.tasks.create(task_params)
      render @task
    rescue ActionController::ParameterMissing
      render_error 422
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end

    def update
      @task.update!(task_params)
      render @task
    rescue ActionController::ParameterMissing
      render_error 422
    end

    def destroy
      @task.destroy
      render @task
    end

    def finish
      @task.finish!
      render @task
    end

    def to_progress
      @task.to_progress!
      render @task
    end

    private

    def task_params
      params.require(:task).permit(:name, :desc, :deadline, :position)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end

    def get_project
      current_user.projects.find(params[:project_id])
    end
  end
end
