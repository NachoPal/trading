Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'tests#index', as: 'index'
  get 'account/:id/generated-reports' => 'reports#generate', as: 'generate_reports'#, :defaults => { :format => 'pdf' }
  get 'account/:id/cache' => 'reports#cache', as: 'cache', :defaults => { :format => 'pdf' }

  get 'new-test' => 'tests#new', as: 'tests'

  post 'new-test' => 'tests#create', as: 'account_test'
  #get ':id/create-test' => 'tests#create', as: 'create_test'

end
