module V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!

    def create
      @project = current_user.projects.create(project_params)
      render @project
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    end

    def show
      @project = current_user.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 403
    end

    private

    def project_params
      params.require(:project).permit(:title)
    end
  end
end