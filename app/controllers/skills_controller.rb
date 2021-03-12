class SkillsController < ApplicationController
	before_action :set_skill, only: [:show, :update, :destroy]

	# GET /skills
	def index
		allSkills = Skill.all
		@skills 	= allSkills.map { |skill| skill.label	 }
		json_response(@skills)
	end

	# skill /skills
	def create
		@skill = Skill.create!(skill_params)
		json_response(@skill, :created)
	end

	# GET /skills/:id
	def show
		json_response(@skill)
	end

	# PUT /skills/:id
	def update
		@skill.update(skill_params)
		head :no_content
	end

	# DELETE /skills/:id
	def destroy
		@skill.destroy
		head :no_content
	end

	private

	def skill_params
		# whitelist params
		params.permit(:label)
	end

	def set_skill
		@skill = skill.find(params[:id])
	end
end
