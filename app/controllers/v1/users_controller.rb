module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!

    api :GET, '/users/:id'
    param :id, :number
    def show
      @user = current_user
    end
  end
end
