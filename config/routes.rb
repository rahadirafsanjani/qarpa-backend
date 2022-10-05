Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      namespace :users do
        post 'auth/signup', to: 'registrations#create'
        post 'auth/signin', to: 'sessions#login' 
      end
    end
  end
end
