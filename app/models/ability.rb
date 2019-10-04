class Ability
  include CanCan::Ability

  def initialize user
    can :read, Product
    return if user.blank?
    can [:show, :update, :change_password, :update_change_password],
      User, id: user.id
    can [:new, :create], Order
    return can :manage, :all if user.admin?
  end
end
