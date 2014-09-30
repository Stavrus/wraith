class InviteClan
  include Wisper::Publisher

  def call(user, target)

    # Verify we actually have a sender to use
    if user.nil?
      publish(:invite_clan_failed, ['Missing sender.'])
      return
    end

    # Verify sender is actually part of a clan
    if user.clan.nil?
      publish(:invite_clan_failed, ['Sender is not part of a clan.'])
      return
    end

    # Verify we actually have a target to use
    if target.nil?
      publish(:invite_clan_failed, ['Missing target.'])
      return
    end

    # Verify target and sender are not the same
    if user == target
      publish(:invite_clan_failed, ['You cannot invite yourself to a clan.'])
      return
    end

    invite = ClanInvite.create_with(sender: user)
                       .find_or_create_by({clan: user.clan, user: target, pending: true})
                       
    publish(:invite_clan_successful)
  end

end