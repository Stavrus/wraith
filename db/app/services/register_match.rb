class RegisterMatch
  include Wisper::Publisher

  def call(match, user, oz_interest)

    # Verify we actually have a match to use
    if match.nil?
      publish(:register_match_failed, ['Missing match.'])
      return
    end

    # Verify we actually have a user to use
    if user.nil?
      publish(:register_match_failed, ['Missing user.'])
      return
    end

    match_user = MatchUser.new({:match => match, :user => user, :oz_interest => oz_interest || false})
    if !match_user.save
      publish(:register_match_failed, match_user.errors.full_messages)
      return
    end

    for i in 1..2
      token = Token.create!(:match => match, :match_user => match_user, :rank => i)
    end

    publish(:register_match_successful, match_user)
  end

end