class UserSerializer < ActiveModel::Serializer
  attributes :id, :clan_id, :clan, :name, :email, :avatar, :avatar_approval_requested, :authentication_token, :auth_expires, :role

  def clan
    object.clan.name if object.clan
  end

  def avatar
    object.avatar_url
  end

  def include_email?
    scope == object
  end

  def include_avatar_approval_requested?
    scope != nil && scope.moderator?
  end

  def include_authentication_token?
    scope == object
  end

  def include_auth_expires?
    scope == object
  end

  def role
    object.role.name
  end

end