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

        get 'show/:id', to: 'users#show'
        post 'create', to: 'users#create'
        put 'update/:id', to: 'users#update'
        delete 'delete/:id', to: 'users#delete'
      end
      
      #branches 
      scope 'branches' do
        post 'create', to: 'branches#create'
        put 'close/:id', to: 'branches#close'
        put 'open/:id', to: 'branches#open'
      end

      #customers 
      scope 'customers' do
        post 'create', to: 'customers#create'
        put 'update/:id', to: 'customers#update'
        delete 'delete/:id', to: 'customers#destroy' 
      end
    end
  end
end
