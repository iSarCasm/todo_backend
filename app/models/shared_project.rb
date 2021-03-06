class SharedProject < ApplicationRecord
  belongs_to :project

  validates :url, uniqueness: true
  validates :project_id, uniqueness: true

  before_save :set_url

  def user
    project.user
  end

  private

  def set_url
    self.url ||= SecureRandom.hex 20
  end
end
