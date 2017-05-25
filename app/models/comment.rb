class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :content, presence: true

  mount_uploaders :attachments, AttachmentUploader

  alias_method :author, :user
  alias_method :owner, :user

  def task_owner
    task.owner
  end
end
