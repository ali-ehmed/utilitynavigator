Rails.application.routes.draw do
  get "sitemap.xml" => "sitemaps#index", :format => "xml", :as => :sitemap
  resources :payments

  get 'ping' => proc {|env| [200, {}, []] }

  resources :offers, only: :index do
    resources :checkout, controller: 'offers/checkout'do
      post "/" => "offers/checkout#show"
    end
  	collection do
  		get "show" => "offers#show"
      get "broadband_providers" => "offers#broadband_providers", :constraints => {:format => /(json)/}
  	end
  end

  %w(cox charter_spectrum twc dashboard).each do |proivder|
    get proivder => "landings##{proivder}"
  end

  get "/compare_packages" => "landings#compare_packages"
  get "/load_channels" => "landings#load_channels"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # devise_for :users, controllers: { sessions: "users/sessions", :registrations => "users/registrations" }
  devise_for :users, :skip => [:registrations], controllers: { sessions: "users/sessions", :registrations => "users/registrations" }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', :as => 'registration'
    delete 'users/:id' => 'devise/registrations#destroy', :as => 'destroy_user_registration'
  end

  resources :call_back, only: [:create]
  root to: 'landings#index'
end
