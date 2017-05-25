class SharedProject < ApplicationRecord
  belongs_to :project

  validates :url, uniqueness: true
end
