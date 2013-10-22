class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # basic permissions
    unless user.blank?
        can [:read, :update, :create], ContestSuggestion
        can [:read, :update, :create], StaffTicket
        can [:read, :update, :create], TransmitterLogEntry
        can [:read], Psa
        can [:read, :create], PsaReading
        can [:read], ListenerLog

        can :manage, ListenerTicket, contest: {sent: false}

        can :read, :all

        # admin
        if user.admin?
          can :manage, :all
        end

        # contest director
        if user.has_role? :contest_director
          can :manage, Contest
          can :manage, Venue
          can :manage, StaffTicket
        end

        # psa director
        if user.has_role? :psa_director
            can :manage, Psa
            can :manage, PsaReading
        end
    end
  end
end
