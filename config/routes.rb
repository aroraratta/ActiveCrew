Rails.application.routes.draw do

  namespace :admin do
    get 'posts/index'
  end
  # 共用
  root to: "homes#about"
  get "top" => "homes#top"
  get "searches" => "searches#search"
  resources :cities, only: [:index]

  # 管理者用
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  namespace :admin do
    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :update, :destroy]
    resources :circles, only: [:index, :show, :update, :destroy]
  end

  # 利用者用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  scope module: :public do
    resources :circles do
      resource :circle_users, only: [:create, :destroy]
    end
    resources :posts, except: [:index] do
      resources :post_comments, only: [:create, :update, :destroy]
    end
    get "mypage" => "users#show", as: "mypage"
    get "mypage/edit" => "users#edit", as: "edit_mypage"
    patch "users/information/:id/update" => "users#update", as: "update_information"
    get "users/information/:id" => "users#show", as: "user"
    get "/users/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
    patch "/users/withdraw" => "users#withdraw", as: "withdraw"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
