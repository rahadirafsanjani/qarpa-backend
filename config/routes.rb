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
      get 'branches/:id', to: 'branches#show'
      get 'employee/branches', to: 'branches#get_for_employee'

      #work order management
      get 'work_managements', to: 'management_works#index'
      get 'work_managements/:id', to: "management_works#show"
      post 'work_managements', to: "management_works#create"
      put 'work_managements/update/:id', to: 'management_works#update'
      
      #work order management for employee
      scope 'employee' do 
        get 'work_managements', to: 'management_works#get_for_employee'
        put 'work_managements/:id', to: "management_works#done"
      end

      #pos
      scope 'branches/pos' do
        post 'open', to: 'pos#open'
        put 'close/:id', to: 'pos#close'
      end

      #customers 
      get 'customers', to: 'customers#index'
      scope 'customers' do
        post 'create', to: 'customers#create'
        put 'update/:id', to: 'customers#update'
        delete 'delete/:id', to: 'customers#destroy' 
      end

      #order 
      post 'orders', to: 'orders#create'

      #leave management
      post 'leave_managements', to: 'leave_managements#create'
      put 'leave_managements/actions', to: 'leave_managements#action'
    end
  end
end
