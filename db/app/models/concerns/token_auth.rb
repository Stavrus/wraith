module TokenAuth
  extend ActiveSupport::Concern
  # Fork of DeviseTokenAuth commit 34e8d92a1d0a41fabc4e67e4cbdab2ef47fcc9fa
  # Necessary to focus solely on tokens (original pulls in database authenticable)

  included do
    serialize :tokens, JSON

    after_save :set_empty_token_hash
    after_initialize :set_empty_token_hash
  end

  def valid_token?(token, client_id='default')
    client_id ||= 'default'

    return false unless self.tokens[client_id]

    return true if token_is_current?(token, client_id)
    return true if token_can_be_reused?(token, client_id)

    # return false if none of the above conditions are met
    return false
  end


  def token_is_current?(token, client_id)
    return true if (
      # ensure that expiry and token are set
      self.tokens[client_id]['expiry'] and
      self.tokens[client_id]['token'] and

      # ensure that the token was created within the last two weeks
      DateTime.strptime(self.tokens[client_id]['expiry'].to_s, '%s') > DeviseTokenAuth.token_lifespan.ago and

      # ensure that the token is valid
      BCrypt::Password.new(self.tokens[client_id]['token']) == token
    )
  end


  # allow batch requests to use the previous token
  def token_can_be_reused?(token, client_id)
    return true if (
      # ensure that the last token and its creation time exist
      self.tokens[client_id]['updated_at'] and
      self.tokens[client_id]['last_token'] and

      # ensure that previous token falls within the batch buffer throttle time of the last request
      Time.parse(self.tokens[client_id]['updated_at']) > Time.now - DeviseTokenAuth.batch_request_buffer_throttle and

      # ensure that the token is valid
      BCrypt::Password.new(self.tokens[client_id]['last_token']) == token
    )
  end


  # update user's auth token (should happen on each request)
  def create_new_auth_token(client_id=nil)
    client_id  ||= SecureRandom.urlsafe_base64(nil, false)
    last_token ||= nil
    token        = SecureRandom.urlsafe_base64(nil, false)
    token_hash   = BCrypt::Password.create(token)
    expiry       = (Time.now + DeviseTokenAuth.token_lifespan).to_i

    if self.tokens[client_id] and self.tokens[client_id]['token']
      last_token = self.tokens[client_id]['token']
    end

    self.tokens[client_id] = {
      token:      token_hash,
      expiry:     expiry,
      last_token: last_token,
      updated_at: Time.now
   }

    self.save!

    return build_auth_header(token, client_id)
  end


  def build_auth_header(token, client_id='default')
    client_id ||= 'default'

    # client may use expiry to prevent validation request if expired
    # must be cast as string or headers will break
    expiry = self.tokens[client_id]['expiry'].to_s

    return {
      "access-token" => token,
      "token-type"   => "Bearer",
      "client"       => client_id,
      "expiry"       => expiry,
      "uid"          => self.uid
    }
  end


  def build_auth_url(base_url, args)
    args[:uid]    = self.uid
    args[:expiry] = self.tokens[args[:client_id]]['expiry']

    generate_url(base_url, args)
  end


  def extend_batch_buffer(token, client_id)
    self.tokens[client_id]['updated_at'] = Time.now
    self.save!

    return build_auth_header(token, client_id)
  end

  protected


  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end


  def serializable_hash(options={})
    options ||= {}
    options[:except] ||= [:tokens]
    super(options)
  end


  # only validate unique email among users that registered by email
  def unique_email_user
    if provider == 'email' and self.class.where(provider: 'email', email: email).count > 0
      errors.add(:email, "This email address is already in use")
    end
  end

  def set_empty_token_hash
    self.tokens ||= {}
  end

end