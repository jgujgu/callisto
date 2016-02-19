Rails.application.routes.draw do
  mount Spree::Core::Engine, :at => '/'
end

Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :stores
    resources :day_hours
  end
end
