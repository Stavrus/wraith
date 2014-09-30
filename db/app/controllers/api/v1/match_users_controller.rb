class Api::V1::MatchUsersController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => :index
  skip_before_action :authenticate_privileged_action, :only => :index

  def index
    if current_user && current_user.moderator?
      users = MatchUser.eager_load(:team, :tokens, user: :clan).filter(params).order(tags_count: :desc)
      render :json => users
    else
      users = MatchUser.eager_load(:team, user: :clan).filter(params).order(tags_count: :desc)
      render :json => users
    end
  end

  def print
    match_users = MatchUser.active_match.where(:printed => false, :waiver => true, :bandanna => true)
    match_users.update_all(:printed => true)
    render :json => match_users
  end

  def show
    user = MatchUser.eager_load(:tokens).find_by_id params[:id]
    render :json => user
  end

  def update
    user = MatchUser.find_by_id params[:id]

    if user.update match_user_params
      render :json => user
    else
      render :json => {:errors => user.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  protected

    def match_user_params
      params.require(:match_user).permit(:waiver, :bandanna, :printed)
    end

end