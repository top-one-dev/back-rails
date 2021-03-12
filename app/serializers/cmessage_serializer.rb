class CmessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :conversation_id, :attach, :user, :created_at

  def user
  	{ id: object.user.id, name: object.user.name, avatar: object.user.avatar.url, picture: object.user.picture }
  end
end
