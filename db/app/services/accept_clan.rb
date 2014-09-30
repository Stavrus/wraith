class AcceptClan
  include Wisper::Publisher

  def call(user, invite)

    # Verify we actually have a sender to use
    if user.nil?
      publish(:accept_clan_failed, ['Missing user.'])
      return
    end

    # Verify we actually have an invite to use
    if invite.nil?
      publish(:accept_clan_failed, ['Missing invite.'])
      return
    end

    # Verify user is not being invited to the same clan
    if user.clan == invite.clan
      publish(:accept_clan_failed, ['You cannot accept an invite to the same clan you are already in.'])
      return
    end

    user.clan = invite.clan
    user.save
    invite.pending = false
    invite.accepted = true
    invite.save
                       
    publish(:accept_clan_successful)
  end

end