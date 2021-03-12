class User < ApplicationRecord

	has_secure_password

	# Model associations
	has_many :posts, dependent: :destroy
	has_many :comments
	has_many :replies

	has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
	has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy                                  
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	has_and_belongs_to_many :conversations, dependent: :destroy
	has_many :cmessages, dependent: :destroy                             
	
	# Validations
	validates_presence_of :name, :email, :password_digest

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	mount_base64_uploader :avatar, AvatarUploader, file_name: -> (u) { "#{u.id}-#{Time.now.to_s.parameterize}" }

	def self.create_user_for_google(data)                  
		where(email: data["email"]).first_or_initialize.tap do |user|
			user.provider					= "google_oauth2"
			user.uid 							= data["email"]
			user.name 						= "#{data['given_name']} #{data['family_name']}"
			user.email 						= data["email"]
			user.picture 					= data["picture"] 
			user.password_digest 	= SecureRandom.hex(10)
			user.save!
		end
	end

	def self.create_user_for_facebook(data)
		where(email: data["email"]).first_or_initialize.tap do |user|
			user.provider					= "facebook_oauth2"
			user.uid 							= data["userID"]
			user.name 						= data["name"]
			user.email 						= data["email"]
			user.picture 					= data["picture"]["data"]["url"] 
			user.password_digest 	= SecureRandom.hex(10)
			user.save!
		end
	end

	def self.create_user_for_linkedin(data)
		where(email: data["email"]).first_or_initialize.tap do |user|
			user.provider					= "linkedin_oauth2"
			user.uid 							= data["id"]
			user.name 						= "#{data["localizedFirstName"]} #{data["localizedLastName"]}"
			user.email 						= data["email"]
			user.picture 					= data["profilePicture"]["displayImage"]
			user.tagline 					= data["localizedHeadline"]			
			user.password_digest 	= SecureRandom.hex(10)
			user.save!
		end
	end

	def self.search(query)
		if Rails.env.production?
  		where('name ILIKE :query OR
  					 email ILIKE :query OR 
  					 address ILIKE :query OR 
  					 phone ILIKE :query OR 
  					 tagline ILIKE :query OR 
  					 description ILIKE :query OR
  					 skills ILIKE :query', query: "%#{query}%")
  	else
  		where('name LIKE :query OR
  					 email LIKE :query OR 
  					 address LIKE :query OR 
  					 phone LIKE :query OR 
  					 tagline LIKE :query OR 
  					 description LIKE :query OR
  					 skills LIKE :query', query: "%#{query}%")
  	end
	end

	def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

	# Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def online?
	  !Redis.new.get("user_#{self.id}_online").nil?
	end

end
