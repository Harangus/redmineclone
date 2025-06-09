class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user # if user not signed in, he has no rights

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :read, User
      can [:read, :update], Project
      cannot :create, User
      cannot [:create, :destroy], Project
      can [:edit, :update, :destroy], User, id: user.id
    end
  end
end
