class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at, :updated_at, :comments
  belongs_to :user
  def comments
    object.comments.map do |comment|
      CommentSerializer.new(comment, scope: scope, root: false)
    end
  end
end
