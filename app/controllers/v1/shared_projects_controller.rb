module V1
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :set_project, only: [:create]
    authorize_resource

    def show
      @shared_project = SharedProject.find_by!(project_id: params[:project_id])
    end

    def create
      @shared_project = SharedProject.create!(project: @project)
      render @shared_project
    end

    def destroy
      @shared_project = current_user.shared_projects.find_by!(project_id: params[:project_id])
      @shared_project.destroy!
      render @shared_project
    end

    private

    def set_project
      @project = current_user.projects.find(params[:project_id])
    end
  end
end
