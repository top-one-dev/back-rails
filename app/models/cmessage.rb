class Cmessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  mount_uploader :attach, AvatarUploader
  after_create_commit {MessageBroadcastJob.perform_now self}
end
