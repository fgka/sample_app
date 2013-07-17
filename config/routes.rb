SampleApp::Application.routes.draw do

  # Devise Routes
  match 'users/create' => 'users#create', via: 'post', as: 'create'
  #match 'users/(:id)' => 'users#update', via: 'put', as: 'update'
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
  
  #match 'users/(:id)/edit' => 'users#edit', via: 'get'

  #Other resources
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  match '/signup', to: 'users#new'

  root to: 'static_pages#home'

  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

end
