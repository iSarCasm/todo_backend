class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    guest_ability
    user_ability(user) if user.id
  end

  private

  def guest_ability
    can :read, Stats
    can :read, SharedProject
  end

  def user_ability(user)
    can :manage, User, id: user.id

    can :manage, Project, user_id: user.id

    can :manage, Task do |task|
      task.owner == user
    end

    can :update, Comment, user_id: user.id
    can [:create, :destroy], Comment do |comment|
      comment.task_owner == user
    end
    can :create, Comment do |comment|
      comment.project.shared?
    end
    can :destroy, Comment, user_id: user.id

    can :manage, SharedProject, user: user
  end
end
