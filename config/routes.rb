Rails.application.routes.draw do
  root 'home#top'

  get    '/login',  to:'sessions#new'
  post   '/login',  to:'sessions#create'
  delete '/logout', to:'sessions#destroy'

  get    '/users/serch',   to:'users#serch'
  get    '/posts/serch',   to:'posts#serch'

  resources :users do
    member do
      get    :edit_image,   :edit_post, :following, :followed, :setting
      delete :admin_destroy #管理者権限による削除
      patch  :update_image, :update_post, :update_setting
    end
  end

  resources :posts
  resources :likes,               only:[:create, :destroy]
  resources :relationships,       only:[:create, :destroy]
  resources :account_activations, only:[:edit]

end
