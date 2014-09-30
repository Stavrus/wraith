class VoteTier
  include Wisper::Publisher

  def call(match_user, tier, option)

    # Verify we actually have a user
    if match_user.nil?
      publish(:vote_tier_failed, ['Missing user.'])
      return
    end

    # Verify we actually have a user
    if tier.nil?
      publish(:vote_tier_failed, ['Missing tier.'])
      return
    end

    # Verify we actually have a user
    if option.nil?
      publish(:vote_tier_failed, ['Missing option.'])
      return
    end

    # Verify user can actually vote for the tier by team
    if match_user.team != tier.team
      publish(:vote_tier_failed, ['User is ineligible to vote on this tier.'])
      return
    end

    # Verify user can actually vote for the tier by match
    if match_user.match != tier.match
      publish(:vote_tier_failed, ['User is ineligible to vote on this tier.'])
      return
    end

    # Verify the option actually belongs to the tier
    if option.tier != tier
      publish(:vote_tier_failed, ['Option does not belong to given tier.'])
      return
    end

    # Perform the vote
    tier.tier_options.each do |x|
      x.unliked_by match_user.user
    end

    option.liked_by match_user.user
                       
    publish(:vote_tier_successful)
  end

end