Rails.application.routes.draw do
  resources :projects
  resources :employees
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'employees#index'
  resources :employees do
    post 'assign_projects', on: :collection
  end
  get '/employee_history', to: 'employees#history', as: 'employee_history'

end
