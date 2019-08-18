Rails.application.routes.draw do
  resources :departments
  comfy_route :cms_admin, :path => '/cms_admin'

  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/cms', :sitemap => false

  resources :photos
  resources :order_items
  resources :orders do
    collection do
      get :cart
      get :checkout
      get :order_by_available_day
      get :choose_date
      get :view
      post :place_order
      post :stripe_charge
    end
    member do
      get :details
    end
  end
  resources :products do
    collection do
      get :multiple_edit
      get :available_day_multiple_edit
      post :available_day_multiple_update
    end
    member do
      post :review
    end
  end
  resources :categories
  
  resources :chefs do
    collection do
      get :become
    end
  end

  resources :demos
  devise_for :user, :path => '', 
    :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
    :controllers => {
      :registrations => "users/registrations",
      :omniauth_callbacks => "users/omniauth_callback" 
    }
  get 'home/index2'
  get 'home/error_page'
  get 'home/index'
  get 'home/profile'
  root 'home#index'
  get 'home/privacy'
  get 'home/user_term'
  get 'users/profile_show'
  get 'users/setting'
  post 'users/update_setting'
  get '/fetch_products', to: 'home#daily', as: 'fetch_products'
  get '/card/new', to: 'billing#new_card', as: 'add_payment_method'
  post '/card', to: 'billing#create_card', as: 'create_payment_method'
  get '/success', to: 'billing#success', as: 'success'
  post '/yuansfer/ipn', to: 'yuansfer#ipn'
  get 'yuansfer/callback', to: 'yuansfer#callback'
  post '/yuansfer/callback', to: 'yuansfer#callback'
  get '/yuansfer/test', to: 'yuansfer#test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
