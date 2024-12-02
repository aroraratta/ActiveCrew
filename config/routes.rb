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
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'users/:id', to: 'users#show', as: 'user'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    get 'users/information/update' => 'users#update', as: 'update_information'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
