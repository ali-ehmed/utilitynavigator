Rails.application.routes.draw do
  resources :payments

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :offers, only: :index do
    resources :checkout, controller: 'offers/checkout'
  	collection do
  		get "show" => "offers#show"
      get "broadband_providers" => "offers#broadband_providers", :constraints => {:format => /(json)/}
  	end
  end

  %w(cox charter_spectrum twc dashboard).each do |proivder|
    get proivder => "landings##{proivder}"
  end

  get "/compare_packages" => "landings#compare_packages"

  devise_for :users, controllers: { sessions: "sessions" }
  # devise_scope :user do
  #   get "/" => "landings#index"
  # end
  
  # devise_for :users
  resources :call_back, only: [:create]
  root to: 'landings#index'
end
