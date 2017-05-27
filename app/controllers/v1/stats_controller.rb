module V1
  class StatsController < ApplicationController
    api! "Show web-site`s public statistics"
    description "Outputs count of user, projects, tasks, etc."
    example '{"users"=>28, "projects"=>3, "tasks"=>9, "comments"=>27}'
    def index
      @stats = Stats.new
      authorize! :read, @stats
      render json: @stats.to_json, status: 200
    end
  end
end
