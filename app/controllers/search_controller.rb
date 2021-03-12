class SearchController < ApplicationController
	skip_before_action :authorize_request, only: [ :index, :gallery ]

  def index
  	query = params[:query]
  	if query.nil?
  		json_response({users: nil, posts: nil }, :error)
  	else
  		user_result = User.search(query)
  		user_result.each_with_index {|user,i| user.password_digest = user.followers.length }
  		post_result = Post.search(query)
  		json_response({users: user_result, posts: post_result })
  	end
  end

  def gallery
    json_response(Gallery.all)
  end
end
