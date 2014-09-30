class Api::V1::ClanInvitesController < Api::V1::BaseApiController
  skip_before_action :authenticate_privileged_action

  def accept
    invite = ClanInvite.find_by_id params[:id]

    acceptClan = ::AcceptClan.new

    acceptClan.on(:accept_clan_successful) do
      render :json => current_user
    end

    acceptClan.on(:accept_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    acceptClan.call current_user, invite
  end

  def reject
    invite = ClanInvite.find_by_id params[:id]

    rejectClan = ::RejectClan.new

    rejectClan.on(:reject_clan_successful) do
      render :json => current_user
    end

    rejectClan.on(:reject_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    rejectClan.call current_user, invite
  end

  def index
    invites = ClanInvite.where('user_id = ? or clan_invites.clan_id = ?', current_user.id, current_user.clan_id)
                        .pending(true)
                        .eager_load(:user, :sender, :clan)
    render :json => invites
  end

  def show
    # Make sure the user can only see invites to themselves or from within their own clan
    invite = ClanInvite.eager_load(:user, :sender, :clan).find_by_id params[:id]

    if current_user == invite.user || current_user.clan == invite.clan
      render :json => invite
    else
      render :json => { error: 'Unauthorized' }, status: :unprocessable_entity
    end
                  
  end

  def create
    target = User.find_by_id params[:user]

    inv = ::InviteClan.new

    inv.on(:invite_clan_successful) do |invite|
      render :json => invite
    end

    inv.on(:invite_clan_failed) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    inv.call current_user, target
  end

end