SampleApp::Application.routes.draw do

  # Devise Routes
  match 'users/create' => 'users#create', via: 'post', as: 'create'
  # milia

  devise_for :users, controllers: {registrations: "milia/registrations",
                                      sessions: 'sessions',
                                      confirmations: 'confirmations',
                                      passwords: 'passwords'}                                     
  resources :users do
    member do
      get :following, :followers
    end
  end

  #Other resources
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  match '/signup', to: 'users#new'

  root to: 'static_pages#home'

  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

end
