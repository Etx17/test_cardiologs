Rails.application.routes.draw do
  root to: "measurements#index"
  # This route handles the form display
  get 'measurements/new', to: 'measurements#new', as: :new_measurement

  # This route handles the form submission
  post 'delineation', to: 'measurements#create'

  # This route displays the processed measurements
  get 'measurements', to: 'measurements#index', as: :measurements
end
