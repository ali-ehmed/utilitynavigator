Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users
  resources :call_back, only: [:create]
  post "send_email" => "landings#send_email"
  root to: 'landings#index'
end
