class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :content, presence: true

  alias_method :author, :user
  alias_method :owner, :user

  def task_owner
    task.owner
  end
end
