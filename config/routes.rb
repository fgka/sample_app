SampleApp::Application.routes.draw do

  # Devise Routes

  match 'users/create' => 'users#create', via: 'post', as: 'create'
  match 'users/(:id)' => 'users#update', via: 'put', as: 'update'
  match 'users/resend_employee_email/(:id)' => 'users#resend_employee_email', via: 'get', as: 'resend_employee_email'

  devise_for :users, :controllers => {:registrations => 'registrations',
                                      :sessions => 'sessions',
                                      :confirmations => 'confirmations',
                                      :passwords => 'passwords'}                                     
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  match 'users/(:id)/edit' => 'users#edit', via: 'get'
#  devise_scope :user do
#    root :to => 'sessions#new'
#    get 'users/sign_out', :to => 'sessions#destroy'
#  end

  #Other resources
  #resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  match '/signup', to: 'users#new'
#  match '/signin',  to: 'sessions#new'
#  match '/signout', to: 'sessions#destroy', via: :delete

  root to: 'static_pages#home'

  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

end
