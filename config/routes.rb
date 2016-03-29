Rails.application.routes.draw do
  mount Spree::Core::Engine, :at => '/'
end

Spree::Core::Engine.routes.append do
  resources :stores, only: [:new, :create, :show]
  get 'connect_stripe', to: 'stores#connect_stripe'
  get 'connect_stripe_complete', to: 'stores#connect_stripe_complete'
  namespace :admin do
    resources :stores
    resources :day_hours
  end
end
