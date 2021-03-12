class PostsController < ApplicationController
	skip_before_action :authorize_request, only: :show
	before_action :set_post, only: [:show, :update, :destroy]


	# GET /posts
	def index
		@posts = current_user.feed
		json_response(@posts)
	end

	# POST /posts
	def create
		@post = current_user.posts.create!(post_params)
		json_response(@post)
	end

	# GET /posts/:id
	def show
		json_response(@post)
	end

	# PUT /posts/:id
	def update
		@post.update(post_params)
		head :no_content
	end

	# DELETE /posts/:id
	def destroy
		@post.destroy
		json_response({ message: Message.destroy_success}, :ok)
	end

	private

	def post_params
		# whitelist params
		params.permit(:title, :content, :attach)
	end

	def set_post
		@post = Post.find(params[:id])
	end
end
