class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :title, :users
  has_many :cmessages
  def users
  	object.users.map { |user| { id: user.id, name: user.name, avatar: user.avatar.url, picture: user.picture }  }  	
  end
end
