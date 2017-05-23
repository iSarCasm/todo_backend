module V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, except: [:create]

    def create
      @task = current_user.projects.find(params[:project_id]).tasks.create(task_params)
      render @task
    rescue ActionController::ParameterMissing => e
      render_error 422
    rescue ActiveRecord::RecordNotFound => e
      render_error 404
    end

    def update
      @task.update!(task_params)
      render @task
    rescue ActionController::ParameterMissing => e
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
      params.require(:task).permit(:name, :desc, :deadline)
    end

    def set_task
      @task = Task.find(params[:id])
      raise ForbiddenResource if @task.project.user != current_user
    rescue ActiveRecord::RecordNotFound => e
      render_error 404
    rescue ForbiddenResource => e
      render_error 403, resource: 'task'
    end
  end
end
