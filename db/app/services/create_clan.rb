class CreateClan
  include Wisper::Publisher

  def call(user, name)

    # Verify we actually have a match_user to use
    if user.nil?
      publish(:create_clan_failed, ['Missing user.'])
      return
    end

    # Verify we actually have a name to use
    if name.nil?
      publish(:create_clan_failed, ['Missing name.'])
      return
    end

    clan = Clan.new({:name => name})
    if !clan.save()
      publish(:create_clan_failed, clan.errors.full_messages)
      return
    end

    user.clan = clan
    user.save()

    publish(:create_clan_successful, user)
  end

end