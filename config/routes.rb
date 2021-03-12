Rails.application.routes.draw do

	resources :conversations, only: [:index, :create]
  resources :messages, only: [:create]

	mount ActionCable.server => '/cable'

  get 'search/index'
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :posts do
		resources :comments do 
			resources :replies
		end
	end

	resources :skills
	resources :relationships, 	only: [:create, :destroy]

	post 		'login', 			to: 'authentication#authenticate'
	post 		'signup', 		to: 'users#create'
	get 		'user/:id', 	to: 'users#show'
	put 		'user/:id', 	to: 'users#update'
	delete 	'user/:id', 	to: 'users#delete'
	get 		'users', 			to: 'users#index'

	post 		'login/google', 	to:'authentication#google_auth'
	post 		'login/facebook', to:'authentication#facebook_auth'
	post 		'login/linkedin', to:'authentication#linkedin_auth'

	post 		'search', 	to: 'search#index'
	get 		'gallery', 	to: 'search#gallery'


end
