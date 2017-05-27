class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_one :shared_project, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80 }
  validates :desc, length: { maximum: 300 }

  include AASM
  aasm do
    state :in_active, initial: true
    state :in_acrhived

    event :archive do
      transitions from: :in_active, to: :in_acrhived
    end

    event :activate do
      transitions from: :in_acrhived, to: :in_active
    end
  end

  def shared?
    !shared_project.nil?
  end
end
