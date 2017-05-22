module V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
      task = Task.find(params[:task_id])
      if task.project.user == current_user
        @comment = task.comments.create(comment_params)
        render @comment
      else
        render json: {'errors': 'Forbidden project'}, status: 403
      end
    rescue ActionController::ParameterMissing => e
      render json: {'errors': 'Parameter missing'}, status: 422
    rescue ActiveRecord::RecordNotFound => e
      render json: {'errors': 'Parameter missing'}, status: 422
    end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end
  end
end
