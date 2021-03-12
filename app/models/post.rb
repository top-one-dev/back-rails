class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates_presence_of :title, :content

  def self.search(query)
  	if Rails.env.production?
  		where('title ILIKE :query OR
  					 content ILIKE :query', query: "%#{query}%")
  	else
  		where('title LIKE :query OR
  					 content LIKE :query', query: "%#{query}%")
  	end
	end
end
