class Api::V1::TeamsController < Api::V1::BaseApiController

  def index
    teams = Team.all
    render :json => teams
  end

  def show
    team = Team.find_by_id params[:id]
    render :json => team
  end

  def create
    team = Team.create team_params
    render :json => team
  end

  def update
    team = Team.find_by_id params[:id]
    team.update team_params
  end

  protected

    def team_params
      params.require(:team).permit(:name)
    end

end