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
        post "auth/refresh_token", to: "sessions#refresh_token"
        #forgot
        post 'password/forgot', to: 'passwords#forgot'
        post 'password/reset', to: 'passwords#reset'
        put 'password/update', to: 'passwords#update'
        
        #get current user from session
        get 'current', to: 'users#current_user'

        get 'dropdown', to: 'users#dropdown_employee'

        # another need with user
        # get 'show'
        get 'get_all', to: "users#index"
        get 'show/:id', to: 'users#show'
        post 'create', to: 'users#create'
        put 'update/:id', to: 'users#update'
        delete 'delete/:id', to: 'users#destroy'
      end

      scope 'inventory' do
        # product
        get "products/:id", to: "products#show_product_by_id"
        get 'products', to: "products#index"
        post 'products', to: 'products#new_product'
        put 'products/:id', to: 'products#update_product'
        delete 'products/:id', to: 'products#delete_product'
        # product on branch
        post 'products/acc_product/:id', to: 'products#accepted_branch_product'
        get 'products/onbranch/:id', to: 'products#get_product_from_branch'
        post 'products/onbranch/:id', to: 'products#create_product_from_branch'
        put 'products/editproduct/:id', to: 'products#update_product_from_branch'
      end
      
      #branches 
      resources :branches, only: %i[ create index show ]
      get "branches/pos/:id", to: "branches#show_pos"
      get 'owner/branches',to: 'branches#get_for_owner'
      get 'employee/branches', to: 'branches#get_for_employee'

      # suppliers 
      resources :suppliers, only: %i[ create update destroy ]

      # dropdown routes
      get "dropdown/units/products", to: "products#units"
      get "dropdown/conditions/products", to: "products#conditions"
      get 'dropdown/branches', to: 'branches#dropdown'
      get "dropdown/suppliers", to: 'suppliers#dropdown'

      #work order management
      resources :management_works, except: %i[ destroy ]
      
      #work order management for employee
      scope 'employee' do 
        get 'management_works', to: 'management_works#get_for_employee'
        get 'management_works/amount', to: 'management_works#task_amount'
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
        get 'show/', to: 'attendances#show'
      end
      get 'employee/attendances/history', to: 'attendances#employee_history'

      # audit
      get "company/reports", to: "audit#reports"
      get 'company/expenses_incomes', to: 'audit#sum_expenses_incomes'
      get 'company/finance', to: 'finance#index'

      # shipping
      scope 'shipping' do
        post 'customer', to: 'shippings#create'
        post 'branch', to: 'shippings#create'
        put 'delivered_success/:id', to: 'shippings#delivered_success'
        get 'item', to: 'shippings#show'
      end

      # category 
      get "categories", to: "categories#index"
      post "categories", to: "categories#create"
    end
  end
end
