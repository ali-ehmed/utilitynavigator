Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :offers, only: :index do
    resources :checkout, controller: 'offers/checkout'
  	collection do
  		get "show" => "offers#show"
  	end
  end

  %w(cox charter_spectrum twc).each do |proivder|
    get proivder => "landings##{proivder}"
  end
  
  # devise_for :users
  resources :call_back, only: [:create]
  root to: 'landings#index'
end
