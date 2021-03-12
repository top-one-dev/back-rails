class AppearancesBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user_id, online)
    # Do something later
    ActionCable.server.broadcast "appearances_channel",
                                 user_id: user_id,
                                 online: online
  end
end
