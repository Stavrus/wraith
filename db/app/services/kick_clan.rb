class KickClan
  include Wisper::Publisher

  def call(sender, target)

    # Verify we actually have a sender to use
    if sender.nil?
      publish(:kick_clan_failed, ['Missing sender.'])
      return
    end

    # Verify we actually have a target to use
    if target.nil?
      publish(:kick_clan_failed, ['Missing target.'])
      return
    end

    # Verify sender is actually part of a clan
    if sender.clan.nil?
      publish(:kick_clan_failed, ['Sender is not part of a clan.'])
      return
    end

    # Verify target is actually part of a clan
    if target.clan.nil?
      publish(:kick_clan_failed, ['Target is not part of a clan.'])
      return
    end

    # Verify target and sender are not the same
    if sender == target
      publish(:kick_clan_failed, ['You cannot kick yourself from a clan.'])
      return
    end

    # Verify target and sender are part of the same clan
    if sender.clan != target.clan
      publish(:kick_clan_failed, ['You cannot kick someone from a different clan.'])
      return
    end

    target.clan = nil
    target.save
                       
    publish(:kick_clan_successful)
  end

end