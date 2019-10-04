class Ability
  include CanCan::Ability

  def initialize user
    can [:read, :search, :search_product], Product
    return if user.blank?
    if user.admin?
      can :manage, :all
    else
      can [:show, :update, :change_password, :update_change_password],
        User, id: user.id
      can [:new, :create], Order
    end
  end
end
