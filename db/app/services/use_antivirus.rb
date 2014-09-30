class UseAntivirus
  include Wisper::Publisher

  def call(match_user, av)

    # Verify we actually have a match_user to use
    if match_user.nil?
      publish(:use_antivirus_failed, ['Missing user.'])
      return
    end

    # Verify we actually have an av to use
    if av.nil?
      publish(:use_antivirus_failed, ['Missing av.'])
      return
    end

    # Verify user is a zombie
    if match_user.team.name != 'Zombie'
      publish(:use_antivirus_failed, ['User is not a zombie.'])
      return
    end

    # Verify AV is usable
    if !av.match_user.nil?
      publish(:use_antivirus_failed, ['AV has already been claimed.'])
      return
    end

    # Verify AV and match user are part of the same match
    if av.match != match_user.match
      publish(:use_antivirus_failed, ['Cannot use AVs from other matches.'])
      return
    end

    match_user.team = Team.find_by_name 'Human'
    match_user.save
    av.match_user = match_user
    av.save

    publish(:use_antivirus_successful, match_user)
  end

end