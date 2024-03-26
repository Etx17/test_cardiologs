Rails.application.routes.draw do
  root to: "measurements#index"
  post 'delineation', to: 'measurements#create'
  resources :measurements, except: [:create]
end
