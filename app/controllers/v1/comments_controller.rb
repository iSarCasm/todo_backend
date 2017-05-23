module V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, except: [:create]

    def create
      @comment = get_task.comments.create(comment_params)
      render @comment
    rescue ForbiddenResource => e
      render_error 403, resource: 'comment'
    rescue ActionController::ParameterMissing => e
      render_error 422
    rescue ActiveRecord::RecordNotFound => e
      render_error 404
    end

    def update
      if @comment.task.project.user == current_user
        @comment.update!(comment_params)
        render @comment
      else
        render_error 403, resource: 'comment'
      end
    rescue ActionController::ParameterMissing => e
      render_error 422
    end

    def destroy
      if @comment.user == current_user || @comment.task.project.user == current_user
        @comment.destroy
        render @comment
      else
        render_error 403, resource: 'comment'
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_error 404
    end

    def get_task
      task = Task.find(params[:task_id])
      raise ForbiddenResource if task.project.user != current_user
      task
    end
  end
end
