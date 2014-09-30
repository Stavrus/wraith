class AuthorizeUser
  include Wisper::Publisher

  def call(token)

    # Verify we actually have an access token to use
    if token.nil?
      publish(:authorize_user_failed, ['Missing access token.'])
      return
    end

    # Verify token against the Google API
    tok_options = { :body => { :access_token => token } }
    tok_response = HTTParty.post('https://www.googleapis.com/oauth2/v1/tokeninfo', tok_options)

    if tok_response.code != 200
      publish(:authorize_user_failed, ['Invalid token.'])
      return
    end

    # Verify the token was generated for our application
    if tok_response.parsed_response['audience'] != Rails.application.secrets.google_client_id
      publish(:authorize_user_failed, ['Access token invalid for application.'])
      return
    end

    # Associate the user with the access token
    user = User.find_by_email tok_response.parsed_response['email']
    if user
      # Refresh the token
      user.refresh_authentication_token()
    else
      # User doesn't exist, create them with info from Google API
      usr_options = { :headers => { 'authorization' => "Bearer #{token}" } }
      usr_response = HTTParty.get('https://www.googleapis.com/oauth2/v1/userinfo', usr_options)

      if usr_response.code != 200
        publish(:authorize_user_failed, ['Google API request failure during access of user info.'])
        return
      else
        user = User.new(:email => usr_response.parsed_response['email'],
                        :name  => usr_response.parsed_response['name'],
                        :uid   => usr_response.parsed_response['id'],
                        :provider => 'google',
                        :role => Role.find_by_name('Normal'))
      end
    end

    # Update login count and save all changes
    user.ensure_authentication_token()
    if user.save
      publish(:authorize_user_successful, user)
    else
      publish(:authorize_user_failed, user.errors.full_messages)
    end
  end

end