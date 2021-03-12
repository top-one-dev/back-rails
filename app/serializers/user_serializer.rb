class UserSerializer < ActiveModel::Serializer
  attributes :id, :avatar, :name, :email, :phone, :address, :tagline, :description, :skills, :picture
  has_many :posts
  has_many :following
  has_many :followers
  
end
