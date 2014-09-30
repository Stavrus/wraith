class Api::V1::UsersController < Api::V1::BaseApiController
  skip_before_action :authenticate_privileged_action, :only => [:register, :update]

  def register
    match = Match.active

    reg = ::RegisterMatch.new

    reg.on(:register_match_successful) do |match_user|
      render :json => match_user
    end

    reg.on(:register_match_failure) do |errors|
      render :json => {:errors => errors}, :status => :unprocessable_entity
    end

    reg.call match, current_user, params[:oz_interest]
  end

  def index
    users = User.eager_load(:role).filter(params)
    render :json => users
  end

  def show
    user = User.eager_load(:clan).find_by_id params[:id]
    render :json => user
  end

  def update
    user = User.find_by_id params[:id]

    if current_user.moderator? || user == current_user
      if user.update user_params
        render :json => user
      else
        render :json => {:errors => user.errors.full_messages}, :status => :unprocessable_entity
      end
    else
      render :json => { error: 'Unauthorized' }, status: :unprocessable_entity
    end

  end

  protected

    def user_params
      # Accept binary image uploads
      if (params[:user] && params[:user][:avatar_upload])
        params[:user][:avatar] = ::EncodeImage.call params[:user][:avatar_upload], 'avatar.png'
        params.require(:user).permit(:avatar)
      end

      params.require(:user).permit(:name)
    end

end