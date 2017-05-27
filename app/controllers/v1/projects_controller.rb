module V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, except: [:create]
    authorize_resource

    def create
      @project = current_user.projects.create!(project_params)
      render @project
    rescue ActionController::ParameterMissing
      render_error 422
    end

    def show
    end

    def update
      @project.update!(project_params)
      render @project
    rescue ActionController::ParameterMissing
      render_error 422
    end

    def destroy
      @project.destroy!
      render @project
    end

    def archive
      @project.archive!
      render @project
    end

    def activate
      @project.activate!
      render @project
    end

    private

    def project_params
      params.require(:project).permit(:title, :desc)
    end

    def set_project
      @project = current_user.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end
  end
end
