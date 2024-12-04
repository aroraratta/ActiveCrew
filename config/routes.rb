Rails.application.routes.draw do

  # 管理者用
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # 利用者用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  root to: 'homes#about'
  get 'homes/top'

  scope module: :public do
    resources :posts, except: [:index]
    get 'mypage' => 'users#show', as: 'mypage'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    patch 'users/information/update' => 'users#update', as: 'update_information'
    get 'users/information/:id' => 'users#show', as: 'user'
    get '/users/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch '/users/withdraw' => 'users#withdraw', as: 'withdraw'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
