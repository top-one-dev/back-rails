class CommentsController < ApplicationController
	before_action :set_post
	before_action :set_post_comment, only: [:show, :update, :destroy]

	# GET /posts/:post_id/comments
	def index
		json_response(@post.comments)
	end

	# GET /posts/:post_id/comments/:id
	def show
		json_response(@comment)
	end

	# POST /posts/:post_id/comments
	def create
		@comment = @post.comments.new(comment_params)
		@comment.user = current_user
		if @comment.save
			json_response(@comment)
		else
			json_response({ message: @comment.errors }, :error)
		end
	end

	# PUT /posts/:post_id/comments/:id
	def update
		@comment.update(comment_params)
		head :no_content
	end

	# DELETE /posts/:post_id/comments/:id
	def destroy
		if @comment.destroy
			json_response({ message: Message.destroy_success}, :ok)
		else
			json_response({ message: @comment.errors}, :error)
		end
	end

	private

	def comment_params
		params.permit(:content, :attach)
	end

	def set_post
		@post = Post.find(params[:post_id])
	end

	def set_post_comment
		@comment = @post.comments.find_by!(id: params[:id]) if @post
	end
end
