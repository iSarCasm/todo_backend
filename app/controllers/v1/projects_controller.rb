module V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, except: [:create]
    authorize_resource

    api! "Create a new project for current user"
    description "Creates a new project for current user"
    param :project, Hash, desc: 'Project info' do
      param :title, String, desc: 'Title of new project (max length is 80)', required: true
      param :desc, String, desc: 'Project description (max length is 300)'
    end
    example '{"id"=>7, "title"=>"New project", "desc"=>"Some long desc", "in_active"=>true, "tasks"=>[]}'
    def create
      @project = current_user.projects.create!(project_params)
      render @project
    end

    def show
    end

    def update
      @project.update!(project_params)
      render @project
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
    end
  end
end
