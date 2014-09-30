class Api::V1::BaseApiController < ApplicationController
  rescue_from ActionController::ParameterMissing, :with => :param_missing

  before_action :authenticate_user_from_token
  before_action :authenticate_user_action
  before_action :authenticate_privileged_action

  def authenticate_user_from_token
    user_email = request.headers['X-USER-EMAIL'].presence
    user       = user_email && User.where(email: user_email).where('auth_expires > ?', Time.now).first
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, request.headers['X-USER-TOKEN'])
      sign_in user, store: false
    end
  end

  def authenticate_user_action
    if current_user.nil?
      render :json => { error: 'Unauthorized' }, status: :unprocessable_entity
    end
  end

  # Allow only moderators and admins to perform certain actions
  def authenticate_privileged_action
    unless current_user && current_user.moderator?
      render :json => { error: 'Unauthorized' }, status: :unprocessable_entity
    end
  end

  protected

    def param_missing(exception)
      response = { error: "#{exception.param} is required." }
      render :json => response, status: :unprocessable_entity
    end

end
