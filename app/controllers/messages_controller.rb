class MessagesController < ApplicationController
	def create
    message = Cmessage.new(message_params)
    message.user = current_user
    if message.save
      json_response({ msg: "success" })
    end
  end
  
  private
  
  def message_params
    params.permit(:content, :attach, :conversation_id)
  end
end
