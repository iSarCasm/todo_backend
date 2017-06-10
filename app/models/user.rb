class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  mount_uploader :avatar, AvatarUploader

  def tasks
    Task.joins(:project).where(projects: {user_id: id})
  end

  def shared_projects
    SharedProject.joins(:project).where(projects: {user_id: id})
  end
end
