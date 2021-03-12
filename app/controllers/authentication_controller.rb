require 'httparty'
class AuthenticationController < ApplicationController
	
	skip_before_action :authorize_request, only: [ :authenticate, :google_auth, :facebook_auth, :linkedin_auth ]

	# return auth token once user is authenticated
	def authenticate
		auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
		json_response(auth_token: auth_token)
	end

	def google_auth		
		url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["id_token"]}"                  
		response = HTTParty.get(url)                   
		@user = User.create_user_for_google(response.parsed_response)      
		auth_token = JsonWebToken.encode(user_id: @user.id)                      
		json_response(auth_token: auth_token)
	end

	def facebook_auth
		url = "https://graph.facebook.com/v2.3/me?access_token=#{params["id_token"]}&fields=name,email,picture.width(800).height(800)"                  
		response = HTTParty.get(url)        
		@user = User.create_user_for_facebook(response.parsed_response)      
		auth_token = JsonWebToken.encode(user_id: @user.id)                      
		json_response(auth_token: auth_token)
	end

	def linkedin_auth
		url = "https://www.linkedin.com/oauth/v2/accessToken?grant_type=authorization_code&redirect_uri=https://localhost:4000/linkedin&code=#{params['code']}&client_id=#{ENV['LINKEDIN_CLIENT_ID']}&client_secret=#{ENV['LINKEDIN_CLIENT_SECRET']}"
		token = HTTParty.post(url)
		access_token = token.parsed_response['access_token']
		profile = HTTParty.get(
				'https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture,email,localizedHeadline)',
				headers: {
					Authorization: "Bearer #{access_token}"
				}
			)

		if profile.parsed_response['status'] == 403
			json_response( profile.parsed_response, :error)
		else
			@user = User.create_user_for_linkedin(response.parsed_response)      
			auth_token = JsonWebToken.encode(user_id: @user.id)                      
			json_response(auth_token: auth_token)
		end

	end

	private

	def auth_params
		params.permit(:email, :password)
	end
end
