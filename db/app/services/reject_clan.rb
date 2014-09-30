class RejectClan
  include Wisper::Publisher

  def call(user, invite)

    # Verify we actually have a sender to use
    if user.nil?
      publish(:reject_clan_failed, ['Missing user.'])
      return
    end

    # Verify we actually have an invite to use
    if invite.nil?
      publish(:reject_clan_failed, ['Missing invite.'])
      return
    end

    invite.pending = false
    invite.accepted = false
    invite.save
                       
    publish(:reject_clan_successful)
  end

end