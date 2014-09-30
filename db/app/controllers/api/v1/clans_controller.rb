class Api::V1::ClansController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => [:index, :show]
  skip_before_action :authenticate_privileged_action

  def index
    clans = Clan.filter(params)
    render :json => clans
  end

  def show
    clan = Clan.find_by_id params[:id]
    match = Match.active

    # Should look into putting this back into an Arel query
    sql = "SELECT users.id AS id, users.name AS name, teams.name AS team
            FROM USERS
            INNER JOIN clans ON clans.id = users.clan_id
            LEFT OUTER JOIN match_users ON users.id = match_users.user_id
            INNER JOIN teams ON match_users.team_id = teams.id
            WHERE clans.id = #{clan.id} AND match_users.match_id = #{match.id}"
    result = ActiveRecord::Base.connection.execute(sql)

    if !result.nil?
      attributes = ['id', 'name', 'team']
      result.map { |x| x.slice!(*attributes) }

      render :json => { :clan => {:id => clan.id, :name => clan.name, :users => result } }
    else
      render :json => { :clan => [] }
    end
  end

  def create
    createClan = ::CreateClan.new

    createClan.on(:create_clan_successful) do
      render :json => current_user
    end

    createClan.on(:create_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    createClan.call current_user, params[:name]
  end

  def update
    clan = Clan.find_by_id params[:id]

    if clan.update clan_params
      render :json => clan
    else
      render :json => {:errors => clan.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  def leave
    clan = Clan.find_by_id params[:id]

    leaveClan = ::LeaveClan.new

    leaveClan.on(:leave_clan_successful) do
      render :json => current_user
    end

    leaveClan.on(:leave_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    leaveClan.call current_user
  end

  def invite
    clan = Clan.find_by_id params[:id]
    target = User.find_by_id params[:user]

    inviteClan = ::InviteClan.new

    inviteClan.on(:invite_clan_successful) do
      render :json => {}
    end

    inviteClan.on(:invite_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    inviteClan.call current_user, target
  end

  def kick
    clan = Clan.find_by_id params[:id]
    target = User.find_by_id params[:user]

    kickClan = ::KickClan.new

    kickClan.on(:kick_clan_successful) do
      render :json => {}
    end

    kickClan.on(:kick_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    kickClan.call current_user, target
  end

  protected

    def clan_params
      # Accept binary image uploads
      if (params[:clan] && params[:clan][:avatar_upload])
        params[:clan][:avatar] = ::EncodeImage.call params[:clan][:avatar_upload], 'avatar.png'
        params.require(:clan).permit(:avatar)
      end

      params.require(:clan).permit(:name, :description)
    end

end