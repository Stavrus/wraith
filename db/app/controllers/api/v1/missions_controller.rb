class Api::V1::MissionsController < Api::V1::BaseApiController
  skip_before_action :authenticate_privileged_action, only: [:index, :show]

  def index
    missions = Mission.filter(params).showable(current_user, params[:match])
    render :json => missions
  end

  def show
    mission = Mission.find_by_id params[:id]
    render :json => mission
  end

  def create
    mission = Mission.new(mission_params)
    mission.match = Match.active
    if mission.save && mission.errors.empty?
      render :json => mission
    else
      render :json => { :errors => mission.errors.full_messages },
             :status => :unprocessable_entity
    end
  end

  def update
    mission = Mission.find_by_id params[:id]
    mission.update mission_params
    render :json => mission
  end

  protected

    def mission_params
      params.require(:mission).permit(:title, :description, :team_id, :date_release)
    end

end