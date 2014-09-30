class PerformTag
  include Wisper::Publisher

  def call(match, source, target, lat, long)

    # Verify we were given non-null required parameters (lat/long is optional)
    if source.nil?
      publish(:perform_tag_failed, ['No zombie found with given ID.'])
      return
    end
    if target.nil?
      publish(:perform_tag_failed, ['No human found with given ID.'])
      return
    end
    if match.nil?
      publish(:perform_tag_failed, ['No match found with given ID.'])
      return
    end

    # Verify match is underway
    if !verify_match_started(match)
      publish(:perform_tag_failed, ['Game has not yet started.'])
      return
    end

    # Verify users are eligible to play in this match
    if !verify_user_valid(source)
      publish(:perform_tag_failed, ['Zombie needs to see an admin.'])
      return
    end
    if !verify_user_valid(target)
      publish(:perform_tag_failed, ['Human needs to see an admin.'])
      return
    end

    # Verify users are on the appropriate teams
    if !verify_source_valid(source)
      publish(:perform_tag_failed, ['Tagger is not registered as a zombie.'])
      return
    end
    if !verify_target_valid(target)
      publish(:perform_tag_failed, ['Victim is not registered as a human.'])
      return
    end
    
    tag = Tag.new({:match => match,
                   :source => source,
                   :target => target,
                   :latitude => lat,
                   :longitude => long})

    if !tag.save
      publish(:perform_tag_failed, tag.errors.full_messages)
      return
    end

    # award_badges source, target, tag, match

    target.team = source.team
    target.token_rank += 1
    target.save

    publish(:perform_tag_successful, tag)
  end

  private

    def verify_match_started(match)
      DateTime.now >= match.date_start
    end

    def verify_user_valid(user)
      user.waiver && user.bandanna && user.printed
    end

    def verify_source_valid(user)
      user.team.name == 'Zombie'
    end

    def verify_target_valid(user)
      user.team.name == 'Human'
    end

    # Temporary code as future plan is to not make badges hardcoded
    def award_badges(source, target, tag, match)
      now = Time.now

      # Tagged within first hour
      if now < (Match.date_start + 1.hour)
        BadgeUser.create(:user => target.user, :match => match, :badge_id => 3)
      end

      # Tagged first day 6 AM to 9PM
      if Date::DAYNAMES[Date.today.wday] == 'Monday'\
          && now > (Time.now.beginning_of_day + 6.hours)\
          && now < (Time.now.beginning_of_day + 21.hours)
        BadgeUser.create(:user => target.user, :match => match, :badge_id => 4)
      end

      # Tagged twice in a single day
      res = Tag.where(:target => target, :match => match).last(2)
      if res.size == 2 && ((res[0].created_at + 1.day) > res[1].created_at)
        BadgeUser.create(:user => target.user, :match => match, :badge_id => 5)
      end

      # Two tags within an hour of each other
      res = Tag.where(:source => source, :match => match).last(2)
      if res.size == 2 && ((res[0].created_at + 1.hour) > res[1].created_at)
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 6)
      end

      # Multitag badges
      res = Tag.where(:source => source, :match => match).size
      if res >= 3
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 7)
      end

      if res >= 5
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 8)
      end

      if res >= 10
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 9)
      end

      if res >= 15
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 10)
      end

      if res >= 20
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 11)
      end

      if res >= 25
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 12)
      end

      if res >= 30
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 13)
      end

      # 5 tags in a single day
      res = Tag.where(:source => source, :match => match).last(5)
      if res.size == 5
        tally = res.find_all { |x| x.created_at < (res[0].created_at + 1.day) }
        if tally.size == 5
          BadgeUser.create(:user => source.user, :match => match, :badge_id => 14)
        end
      end

      # Get a tag between 6 AM and 9AM
      if now > (Time.now.beginning_of_day + 6.hours)\
         && now < (Time.now.beginning_of_day + 9.hours)
        BadgeUser.create(:user => source.user, :match => match, :badge_id => 16)
      end

      if target.token_rank == 2
        BadgeUser.create(:user => target.user, :match => match, :badge_id => 19)
      end
    end
end