Rails.application.routes.draw do
  mount Spree::Core::Engine, :at => '/'
end

Spree::Core::Engine.routes.append do
  resources :stores, only: [:new, :create, :show]
  namespace :admin do
    resources :stores
    resources :day_hours
  end
end
