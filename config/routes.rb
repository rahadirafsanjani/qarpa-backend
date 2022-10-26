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

        get 'show/:id', to: 'users#show'
        post 'create', to: 'users#create'
        put 'update/:id', to: 'users#update'
        delete 'delete/:id', to: 'users#destroy'
      end

      scope 'inventory' do
        # create product
        post 'products', to: 'products#new_product'
        put 'products/:id', to: 'products#update_product'
        delete 'products/:id', to: 'products#delete_product'
      end
      
      #branches 
      post 'branches', to: 'branches#create'
      get 'branches', to: 'branches#index'
      get 'branch', to: 'branches#get_branch_by_id'

      #pos
      scope 'branches/pos' do
        post 'open', to: 'pos#open'
        put 'close/:id', to: 'pos#close'
      end

      #customers 
      scope 'customers' do
        post 'create', to: 'customers#create'
        put 'update/:id', to: 'customers#update'
        delete 'delete/:id', to: 'customers#destroy' 
      end

      #order 
      post 'orders', to: 'orders#create'
    end
  end
end
