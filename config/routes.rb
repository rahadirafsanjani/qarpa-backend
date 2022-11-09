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
        
        #get current user from session
        get 'current', to: 'users#current_user'

        # another need with user
        # get 'show'
        get 'show/:id', to: 'users#show'
        post 'create', to: 'users#create'
        put 'update/:id', to: 'users#update'
        delete 'delete/:id', to: 'users#destroy'
      end

      scope 'inventory' do
        # create product
        get 'products/suplai', to: "products#show_suplai"
        get 'products/stock', to: "products#show_stock"
        post 'products', to: 'products#new_product'
        put 'products/:id', to: 'products#update_product'
        delete 'products/:id', to: 'products#delete_product'
        # product on branch
        # get 'products/onbranch', to:''
      end
      
      #branches 
      resources :branches, only: %i[ create index show ]
      get 'owner/branches',to: 'branches#get_for_owner'
      get 'employee/branches', to: 'branches#get_for_employee'

      #work order management
      resources :management_works, except: %i[ destroy ]
      
      #work order management for employee
      scope 'employee' do 
        get 'management_works', to: 'management_works#get_for_employee'
        put 'management_works/:id', to: "management_works#done"
      end

      #pos
      scope 'branches/pos' do
        post 'open', to: 'pos#open'
        put 'close', to: 'pos#close'
      end

      #customers 
      resources :customers

      #order 
      post 'orders', to: 'orders#create'

      #leave management
      resources :leave_managements, only: %i[ create index ]
      get 'employee/leave_managements', to: 'leave_managements#get_for_employee'
      put 'leave_managements/actions', to: 'leave_managements#action'

      #bank account
      resources :bank_accounts
      
      # attendance
      scope 'attendances' do
      post 'check_in', to: 'attendances#create'
      put 'check_out', to: 'attendances#update'
      get 'history', to: 'attendances#all_history'
      end

      # shipping
      scope 'shipping' do
        post 'item', to: 'shippings#create'
      end
    end
  end
end
