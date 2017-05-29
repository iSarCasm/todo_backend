module V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, except: [:create]
    authorize_resource

    api! 'Create a new comment'
    description 'Creates a new comment under a given task. Can be created under current user`s task or shared projects`s task.'
    param :task_id, Fixnum, desc: 'Task id'
    param :comment, Hash, desc: 'Comment info' do
      param :content, String, desc: 'Comment text'
      param :attachments, Array, desc: 'Array of images (or other files) to attach'
    end
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    example <<~EOS
      REQUEST:
       {
         "task_id"=>"1",
         "comment"=>{
           "content"=>"Some comment about something",
           "attachments"=>[ %file_1%, ... ]
         }
       }
      RESPONSE:
      {
        "id"=>28,
        "task_id"=>1,
        "content"=>"Some comment about something",
        "attachments"=>[
          {"url"=>"/uploads/comment/attachments/59e19706/bd4aeee8f7.png"},
          {"url"=>"/uploads/comment/attachments/59e19706/d373f5d53b.png"}
        ]
      }
    EOS
    def create
      @comment = get_task.comments.create(comment_params)
      authorize! :create, @comment
      @comment.user = current_user
      @comment.save!
      render @comment
    end

    api! 'Update comment'
    description 'Update comment with new information. Returns comment object upon success.'
    param :id, Fixnum, desc: 'Comment id', required: true
    param :comment, Hash, desc: 'Comment info' do
      param :content, String, desc: 'Comment text', required: true
      param :attachments, Array, desc: 'Array of images (or other files) to attach'
    end
    error 401, 'Unauthorized'
    error 422, 'Parameter missing'
    def update
      @comment.update!(comment_params)
      render @comment
    end

    api! 'Delete comment'
    description 'Deltes a given comment. Has to be owned by current user or placed under user`s project. Returns comment object upon success.'
    param :id, Fixnum, desc: 'Comment id', required: true
    error 401, 'Unauthorized'
    error 404, 'Not found'
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
    end

    def get_task
      Task.find(params[:task_id])
    end
  end
end
