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
    end
  end
  resources :products do
    member do
      post :review
    end
  end
  resources :categories
  resources :chefs
  resources :demos
  devise_for :user, :path => '', 
    :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
    :controllers => {
      :registrations => "users/registrations",
      :omniauth_callbacks => "users/omniauth_callback" 
    }
  get 'home/index2'  
  root 'home#index'
  get 'home/privacy'
  get 'home/user_term'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
