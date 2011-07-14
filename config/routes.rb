Blog::Application.routes.draw do |map|
 root :to => "articles#index"
  resources :articles do
    member do
      post :vote_up
    end
  end
  resources :articles do
    member do
      post :vote_down
    end
  end
  resources :articles do
    member do
      post :notify_friend
    end
    resources :comments
  end
  resources :users
  resource :session
  resources :articles do
    member do
      post 'vote'
    end
  end
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"  
end
