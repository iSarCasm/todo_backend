module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    api! "Show all user information"
    error code: 401, desc: 'Unauthorized'
    description 'Returns all information about current logged in user, including: projects, tasks, comments, etc.'
    formats ['json']
    example <<~EOS
      {
        "uid"=>"2eveline@boyer.biz",
        "name"=>"Celia",
        "email"=>"2eveline@boyer.biz",
        "avatar"=>"/uploads/user/fallback/default.png",
        "projects"=> [{...}, ...]
      }
    EOS
    def show
      @user = current_user
    end
  end
end
