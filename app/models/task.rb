class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  include AASM

  aasm do
    state :in_progess, initial: true
    state :finished

    event :finish do
      transitions from: :in_progess, to: :finished
    end

    event :to_progress do
      transitions from: :finished, to: :in_progess
    end
  end
end
