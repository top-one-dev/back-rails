class ReplySerializer < ActiveModel::Serializer
  attributes :id, :content, :attach, :updated_at, :created_at
  belongs_to :user
end
