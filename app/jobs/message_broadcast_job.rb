class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Do something later
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
        CmessageSerializer.new(message)
      ).serializable_hash
    conversation = message.conversation
    conversation.users.each do |user|
    	ActionCable.server.broadcast "conversations_channel_#{user.id}", serialized_data
    	# CmessagesChannel.broadcast_to "cmessages_channel_#{conversation.id}_#{user.id}", serialized_data
    end    
  end
end
