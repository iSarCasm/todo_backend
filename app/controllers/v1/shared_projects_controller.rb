module V1
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :set_project, only: [:create]

    def show
      @shared_project = SharedProject.find_by!(project_id: params[:project_id])
    end

    def create
      @shared_project = SharedProject.create!(project: @project)
      render @shared_project
    rescue ActiveRecord::RecordInvalid
      render_error 422
    end

    def destroy
      @shared_project = current_user.shared_projects.find_by!(project_id: params[:project_id])
      @shared_project.destroy!
      render @shared_project
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end

    private

    def set_project
      @project = current_user.projects.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end
  end
end
