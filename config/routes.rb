Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "conversations#index"

  # post 'openai/generate_response', to: 'openai#generate_response'

  resources :conversations, only: [:new, :index, :show, :create] do
    resources :messages, only: [:index, :create]
  end

  mount ActionCable.server => '/cable'
end
