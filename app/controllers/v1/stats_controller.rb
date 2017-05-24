module V1
  class StatsController < ApplicationController
    def index
      @stats = Stats.new
      render json: @stats.to_json, status: 200
    end
  end
end
