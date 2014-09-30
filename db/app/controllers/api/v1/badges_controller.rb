class Api::V1::BadgesController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => [:index, :show]
  skip_before_action :authenticate_privileged_action, :only => [:index, :show]

  def index
    badges = Badge.all
    render :json => badges
  end

  def show
    badge = Badge.find_by_id params[:id]
    render :json => badge
  end

  def create
    badge = Badge.create badge_params
    render :json => badge
  end

  def update
    badge = Badge.find_by_id params[:id]
    badge.update badge_params
  end

  protected

    def badge_params
      params.require(:badge).permit(:name)
    end

end