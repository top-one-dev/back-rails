class RelationshipsController < ApplicationController

	# POST /relationships
	def create
		user = User.find(params[:id])
		unless user == current_user
			if current_user.follow(user)
				json_response(user)
			else
				json_response({message: user.errors}, :error)
			end
		else
			json_response(user)
		end		
	end

		# DELETE /relationships/:id
	def destroy
		user = User.find(params[:id])
		if current_user.unfollow(user)
			json_response(user)
		else
			json_response({message: user.errors}, :error)
		end
	end
end
