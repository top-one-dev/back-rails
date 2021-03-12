class ConversationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    # Do something later
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      ConversationSerializer.new(conversation)
    ).serializable_hash
    conversation.users.each do |user|
      ActionCable.server.broadcast "conversations_channel_#{user.id}", serialized_data
    end
  end
end
