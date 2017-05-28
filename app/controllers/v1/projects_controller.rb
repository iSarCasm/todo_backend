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
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    example <<~EOS
      REQUEST:
      {
        "project"=>{
          "title"=>"New project",
          "desc"=>"Some long desc"
        }
      }
      RESPONSE:
      {
        "id"=>7,
        "title"=>"New project",
        "desc"=>"Some long desc",
        "in_active"=>true,
        "tasks"=>[]
      }
    EOS
    def create
      @project = current_user.projects.create!(project_params)
      render @project
    end

    api! "Show project"
    description 'Returns all project information including tasks and their comments'
    param :id, Fixnum, required: true
    example '{"id"=>7, "title"=>"New project", "desc"=>"Some long desc", "in_active"=>true, "tasks"=>[]}'
    error 404, 'Not found'
    error 401, 'Unauthorized'
    def show
    end

    api! "Update project"
    description 'Update project attributes with new values. Returns updated project object upon successful update'
    param :id, Fixnum, required: true
    param :project, Hash, desc: 'Project info' do
      param :title, String, desc: 'Title of new project (max length is 80)'
      param :desc, String, desc: 'Project description (max length is 300)'
    end
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    see 'projects#create', "projects#create"
    def update
      @project.update!(project_params)
      render @project
    end

    api! "Archive project"
    description 'Put project into archived category. Returns updated project object upon successful update'
    param :id, Fixnum, required: true
    error 404, 'Not found'
    error 401, 'Unauthorized'
    see 'projects#show', "projects#show"
    see 'projects#create', "projects#create"
    def archive
      @project.archive!
      render @project
    end

    api! "Activate project"
    description 'Put project into active category. Returns updated project object upon successful update'
    param :id, Fixnum, required: true
    error 404, 'Not found'
    error 401, 'Unauthorized'
    see 'projects#show', "projects#show"
    see 'projects#create', "projects#create"
    def activate
      @project.activate!
      render @project
    end

    api! "Delete project"
    description 'Update project attributes with new values. Returns updated project object upon successful destoy'
    param :id, Fixnum, required: true
    error 404, 'Not found'
    error 401, 'Unauthorized'
    see 'projects#show', "projects#show"
    see 'projects#create', "projects#create"
    def destroy
      @project.destroy!
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
