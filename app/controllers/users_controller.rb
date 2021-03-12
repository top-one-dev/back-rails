class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]
	skip_before_action :authorize_request, only: [:create, :show]

	def index
		users = User.where.not(id: current_user.id)
		json_response(users)
	end

	def create
		user = User.create!(user_params)
		auth_token = AuthenticateUser.new(user.email, user.password).call
		response = { message: Message.account_created }
		json_response(response, :created)
	end

	# GET /user/:id
	def show
		json_response(@user)
	end

	# PUT /user/:id
	def update		
		@user.update(user_params)		
		new_skill user_params[:skills]
		json_response({ message: Message.update_success}, :ok)
	end

	# DELETE /user/:id
	def destroy
		@user.destroy
		json_response({ message: Message.destroy_success}, :ok)
	end

	private

	def user_params
		params.permit(
			:avatar,
			:name,
			:email,
			:password,
			:password_confirmation,
			:phone,
			:address,
			:tagline,
			:description,
			skills: []
		)
	end

	def set_user
		@user = User.find(params[:id])
	end

	def new_skill skills
		all_skills = Skill.all.map { |skill| skill.label  }
		skills.each do |skill|
			unless all_skills.include?(skill)
				if Skill.create!(label: skill)
					puts "success to save new skill : #{skill}"
				else
					puts "failed to save new skill: #{skill}"
				end
			end
		end
	end

end
