module V1
  class TasksController < ApplicationController
    before_action :authenticate_user!

    def create
      @task = current_user.projects.find(params[:project_id]).tasks.create(task_params)
      render @task
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Parameter missing'}, status: 422
    end

    def update
      @task = Task.find(params[:id])
      if @task.project.user == current_user
        @task.update!(task_params)
        render @task
      else
        render json: {'errors': 'Forbidden task'}, status: 403
      end
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 404
    end

    def destroy
      @task = Task.find(params[:id])
      if @task.project.user == current_user
        @task.destroy
        render @task
      else
        render json: {'errors': 'Forbidden task'}, status: 403
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 404
    end

    def finish
      @task = Task.find(params[:id])
      if @task.project.user == current_user
        @task.finish!
        render @task
      else
        render json: {'errors': 'Forbidden task'}, status: 403
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 404
    end

    def to_progress
      @task = Task.find(params[:id])
      if @task.project.user == current_user
        @task.to_progress!
        render @task
      else
        render json: {'errors': 'Forbidden task'}, status: 403
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 404
    end

    private

    def task_params
      params.require(:task).permit(:name, :desc, :deadline)
    end
  end
end
