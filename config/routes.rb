Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :package_bundles, only: :index do 
  	collection do
  		get "show" => "package_bundles#show"
  	end
  end

  %w(cox charter_spectrum twc).each do |proivder|
    get proivder => "landings##{proivder}"
  end
  
  devise_for :users
  resources :call_back, only: [:create]
  root to: 'landings#index'
end
