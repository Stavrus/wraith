class ClanInviteSerializer < ActiveModel::Serializer
  attributes :id, :clan_id, :user_id, :sender_id, :pending, :accepted, :clan, :user, :sender

  def clan
    object.clan.name
  end

  def user
    object.user.name
  end

  def sender
    object.sender.name
  end

end