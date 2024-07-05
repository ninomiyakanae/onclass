Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :bases  
  # resources :approvals

  resources :users do
    collection { post :import }  # こちらが追加されます


    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'edit_notice_info'
      get 'attendances/edit_one_month'
      # patch 'attendances/update_one_month' # この行が追加対象です。
      get 'attendances/working'
      get 'attendances/_fotm_overwork_info'
      # get '_approvals_edit'
      get 'approvals_edit'
      patch 'users/approval_of_monthly_applications'    
      put 'users/create_send'    
      get '/users/:id/edit_basic_info', to: 'users#edit_basic_info'
      get 'users/:id/pending_requests', to: 'users#pending_requests', as: 'pending_requests'
      # get 'apply_for_approval'
      # resources :users, only: [:show, :edit, :update]  # showアクションがcurrent_userのページに該当する場合
    end

    
    
    resources :attendances, only: :update
  end
end