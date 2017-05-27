class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 80 }
  validates :desc, length: { maximum: 300 }

  before_save :set_default_position
  after_save :update_project_tasks_positions

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

  def user
    project.user
  end
  alias_method :owner, :user

  private

  def update_project_tasks_positions
    return unless saved_changes[:position]
    from  = saved_changes[:position].first
    to    = saved_changes[:position].second
    return unless from
    if from < to     # task moved below
      project.tasks
              .where('position > ?', from)
              .where('position <= ?', to)
              .where('id != ?', id)
              .update_all('position = position - 1')
    elsif from > to  # task moved above
      project.tasks
              .where('position >= ?', to)
              .where('position < ?', from)
              .where('id != ?', id)
              .update_all('position = position + 1')
    end
  end



  def set_default_position
    self.position ||= next_postion_in_project
  end

  def next_postion_in_project
    (project.tasks.maximum(:position) || 0) + 1
  end
end
