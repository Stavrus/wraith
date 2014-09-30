class Api::V1::SessionsController < Api::V1::BaseApiController
  skip_before_action :authenticate_user_action, :only => :authorize
  skip_before_action :authenticate_privileged_action

  def authorize
    auth = ::AuthorizeUser.new

    auth.on(:authorize_user_successful) do |user|
      sign_in user, store: false
      render :json => user
    end

    auth.on(:authorize_user_failed) do |errors|
      render :json => { :errors => errors }, :status => :unprocessable_entity
    end

    auth.call(params[:token])
  end

  def profile
    if current_user
      render :json => current_user
    end
  end

  def destroy
    current_user.authentication_token = ''
    if current_user.save
      render :json => { result: 'Success' }
    else
      render :json => { result: 'Error' }, :status => :unprocessable_entity
    end
  end

end