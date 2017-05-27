module V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, except: [:create]
    authorize_resource

    def create
      @comment = get_task.comments.create(comment_params)
      @comment.user = current_user
      @comment.save!
      render @comment
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end

    def update
      @comment.update!(comment_params)
      render @comment
    end

    def destroy
      @comment.destroy!
      render @comment
    end

    private

    def comment_params
      params.require(:comment).permit(:content, {attachments: []})
    end

    def set_comment
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error 404
    end

    def get_task
      current_user.tasks.find(params[:task_id])
    end
  end
end
