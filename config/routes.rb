Rails.application.routes.draw do

  devise_for :users,
  path: '',
  path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
  controllers: {omniauth_callbacks: 'omniauth_callbacks'}

  root 'items#index'

  resources :items do
    member do
      get :confirm
      get :user_buy_screen
      post :pay_jp
      post :create_customer_information
    end
    collection do
      get :search
    end
  end

  resources :users do
    collection do
      get :signup
      get :items_show
      get :profile
      get :card
      get :identification
      get :logout_confirmation
    end
  end

  resources :categories
end

#購入確認画面の表示のためconfirmを追加。itemのid拾うと思われるのでmemberで一旦書いてみる
