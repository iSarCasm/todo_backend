module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    def show
      @user = current_user
    end
  end
end
