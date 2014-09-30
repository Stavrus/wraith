class Api::V1::BadgeUsersController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => [:index, :show]
  skip_before_action :authenticate_privileged_action, :only => [:index, :show]

  def index
    badges = BadgeUser.eager_load(:badge).filter(params)
    render :json => badges
  end

  def show
    badge = BadgeUser.find_by_id params[:id]
    render :json => badge
  end

  def create
    badge = BadgeUser.create badge_params
    render :json => badge
  end

  def update
    badge = BadgeUser.find_by_id params[:id]
    badge.update badge_params
  end

  protected

    def badge_params
      params.require(:badge_user).permit(:name)
    end

end