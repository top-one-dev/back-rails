class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies, dependent: :destroy
  validates_presence_of :content
  mount_uploader :attach, AvatarUploader
end
