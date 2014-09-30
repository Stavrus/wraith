class Api::V1::MatchesController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => :active
  skip_before_action :authenticate_privileged_action, :only => :active

  def active
    render :json => Match.active
  end

  def index
    matches = Match.all
    render :json => matches
  end

  def show
    match = Match.eager_load(:match_users).find_by_id params[:id]
    render :json => match
  end

  def create
    match = Match.create match_params
    render :json => match
  end

  def update
    match = Match.find_by_id params[:id]
    match.update match_params
  end

  protected

    def match_params
      params.require(:match).permit(:title, :reginfo, :date_announce, :date_start, :date_end)
    end

end