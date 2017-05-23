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

    def update
      @project = current_user.projects.find(params[:id])
      @project.update!(project_params)
      render @project
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 403
    end

    def destroy
      @project = current_user.projects.find(params[:id])
      @project.destroy
      render @project
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 403
    end

    def archive
      @project = current_user.projects.find(params[:id])
      @project.archive!
      render @project
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 403
    end

    def activate
      @project = current_user.projects.find(params[:id])
      @project.activate!
      render @project
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Record not found'}, status: 403
    end

    private

    def project_params
      params.require(:project).permit(:title, :desc)
    end
  end
end
