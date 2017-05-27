module V1
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :set_project, only: [:create]
    authorize_resource

    api! 'Show shared project'
    description 'Shows full information about project. Accessed through shared link to any user on internet.'
    param :url, String, desc: 'shared URL', required: true
    example <<~EOS
      RESPONSE:
      {"project_id"=>2, "url"=>"da2f3f41346bf94c8b48acecb3a25442f59d4a7b"}
    EOS
    def show
      @shared_project = SharedProject.find_by!(url: params[:url])
    end

    api! 'Create a shared project'
    description <<~EOS
      Create a shared link for a project. It will make current project and its tasks/comments available for a view to any
      user from internet who has given link. Project has to be owned by current user. Returns shared porject upon success.
    EOS
    example <<~EOS
      REQUEST:
      {"project_id"=>"2"}
      RESPONSE:
      {"project_id"=>2, "url"=>"da2f3f41346bf94c8b48acecb3a25442f59d4a7b"}
    EOS
    param :project_id, Fixnum, desc: 'Project id', required: true
    see 'shared_projects#show', 'shared_projects#show'
    def create
      @shared_project = SharedProject.create!(project: @project)
      render @shared_project
    end

    api! 'Destroy shared porject'
    description 'Destroy shared project link. Has to be owned by current user. Returns shared project upon success.'
    param :url, String, desc: 'shared URL', required: true
    see 'shared_projects#show', 'shared_projects#show'
    def destroy
      @shared_project = current_user.shared_projects.find_by!(url: params[:url])
      @shared_project.destroy!
      render @shared_project
    end

    private

    def set_project
      @project = current_user.projects.find(params[:project_id])
    end
  end
end
