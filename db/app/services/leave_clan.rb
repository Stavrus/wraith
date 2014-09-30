class LeaveClan
  include Wisper::Publisher

  def call(user)

    # Verify we actually have a current_user to use
    if user.nil?
      publish(:leave_clan_failed, ['Missing user.'])
      return
    end

    # Verify user is part of clan
    if user.clan.nil?
      publish(:leave_clan_failed, ['You are not part of a clan.'])
      return
    end

    user.clan = nil
    user.save
                       
    publish(:leave_clan_successful)
  end

end