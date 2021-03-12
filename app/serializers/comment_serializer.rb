class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :attach, :replies, :updated_at, :created_at
  belongs_to :user

  def replies
    object.replies.map do |reply|
      ReplySerializer.new(reply, scope: scope, root: false)
    end
  end
end
