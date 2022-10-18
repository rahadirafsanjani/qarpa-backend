Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      namespace :users do
        # Regist
        post 'auth/signup', to: 'registrations#token_registration'
        post 'auth/signup/reedem', to: 'registrations#token_redeem'
        put 'auth/signup/registration', to: 'registrations#registration'
        # login
        post 'auth/signin', to: 'sessions#login'
        #forgot
        post 'password/forgot', to: 'passwords#forgot'
        post 'password/reset', to: 'passwords#reset'
        put 'password/update', to: 'passwords#update'
        # create product
        post 'inventory/product', to: 'products#new_product'
        delete 'inventory/product/:id', to: 'products#delete_product'
        put 'inventory/product/:id', to: 'products#update_product'
      end
    end
  end
end
