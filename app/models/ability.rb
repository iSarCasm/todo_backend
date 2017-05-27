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
    can :manage, Project, user: user
    can :manage, Task, owner: user
    can :manage, Comment, user: user
    can :manage, SharedProject, user: user
    can :destroy, Comment, task_owner: user
  end
end
