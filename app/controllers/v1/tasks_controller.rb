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

    private

    def task_params
      params.require(:task).permit(:name, :desc, :deadline)
    end
  end
end
