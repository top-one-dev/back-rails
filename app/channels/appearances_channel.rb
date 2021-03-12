class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    redis.set("user_#{current_user.id}_online", "1")
    stream_from("appearances_channel")
    # AppearancesBroadcastJob.perform_now current_user.id, true
  end

  def unsubscribed
    redis.del("user_#{current_user.id}_online")
    # AppearancesBroadcastJob.perform_now current_user.id, false
  end

  private

  def redis
    Redis.new
  end
end
