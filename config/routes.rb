Rails.application.routes.draw do
  get 'static_pages/top'
  get '/signup', to: 'users#new'
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # get 'users/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
