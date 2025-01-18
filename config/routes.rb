Rails.application.routes.draw do

  namespace :admin do
    get 'events/show'
  end
  namespace :public do
    end
  # 共用
  root to: "homes#about"
  get "top" => "homes#top"
  get "searches" => "searches#search"
  resources :cities, only: [:index]
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

  # 管理者用
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :update, :destroy]
    resources :circles, only: [:index, :show] do
      resources :events, only: [:show]
    end
  end

  # 利用者用
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  scope module: :public do
    resources :circles do
      resources :permits, only: [:create, :destroy]
      resources :circle_users, only: [:index, :create, :destroy]
      resources :events, only: [:new, :create, :show, :destroy] do
        resource :attends, only: [:create, :destroy]
      end
    end
    get "/circles/:id/events" => "circles#show", defaults: { format: "json" }
    resources :posts, except: [:index] do
      resources :post_comments, only: [:create, :update, :destroy]
    end
    get "mypage" => "users#show", as: "mypage"
    get "mypage/edit" => "users#edit", as: "edit_mypage"
    patch "users/information/:id/update" => "users#update", as: "update_information"
    get "users/information/:id" => "users#show", as: "user"
    get "/users/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
    patch "/users/withdraw" => "users#withdraw", as: "withdraw"
    resources :users, only: [] do
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
