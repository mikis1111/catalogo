Rails.application.routes.draw do
  devise_for :users
  # ✅ Logout provvisorio via GET wrappato correttamente
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  get 'borrowers/new'
  get 'borrowers/create'
  root "books#index"
  get 'books/borrowed_list', to: 'books#borrowed_list', as: 'borrowed_list_books'
  
  resources :books do
    collection do
      get :export_excel
      get :export_pdf
      post :import
      get :borrowed_list
    end
  end
  resources :borrowers, only: [:new, :create, :index]

  
end