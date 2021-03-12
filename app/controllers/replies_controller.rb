class RepliesController < ApplicationController
	before_action :set_comment
	before_action :set_comment_reply, only: [:show, :update, :destroy]

	# GET /posts/:post_id/comments/:comment_id/replies
	def index
		json_response(@comment.replies)
	end

	# GET /posts/:post_id/comments/:comment_id/replies/:id
	def show
		json_response(@reply)
	end

	# POST /posts/:post_id/comments/:comment_id/replies
	def create
		@reply 			= @comment.replies.new(replies_params)
		@reply.user = current_user
		if @reply.save
			json_response(@reply)
		else
			json_response({ message: @reply.errors }, :error)
		end
	end

	# PUT /posts/:post_id/comments/:comment_id/replies/:id
	def update
		@reply.update(replies_params)
		head :no_content
	end

	# DELETE /posts/:post_id/comments/:comment_id/replies/:id
	def destroy
		if @reply.destroy
			json_response({ message: Message.destroy_success}, :ok)
		else
			json_response({ message: @reply.errors}, :error)
		end
	end

	private

	def replies_params
		params.permit(:content, :attach)
	end

	def set_comment
		@comment = Comment.find(params[:comment_id])
	end

	def set_comment_reply
		@reply = @comment.replies.find_by!(id: params[:id]) if @comment
	end
end
