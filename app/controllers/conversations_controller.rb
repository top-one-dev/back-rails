class ConversationsController < ApplicationController
	def index
    conversations = current_user.conversations
    render json: conversations
  end

  def create
    conversation  = Conversation.new(conversation_params)
    participant   = User.find(params[:userId])    
    if conversation.save
    	conversation.users << current_user
      conversation.users << participant 
      ConversationBroadcastJob.perform_now conversation            
      json_response({ msg: "success" })
    end
  end
  
  private
  
  def conversation_params
    params.require(:conversation).permit(:title)
  end
end
