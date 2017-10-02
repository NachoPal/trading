Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'generated-reports/:id/' => 'reports#generate', as: 'generate_reports', :defaults => { :format => 'pdf' }
  get 'cache/:id/' => 'reports#cache', as: 'cache', :defaults => { :format => 'pdf' }

  get ':id/new-test/' => 'tests#new', as: 'new_test'

  post ':id/create-test' => 'tests#create', as: 'create_test'
  #get ':id/create-test' => 'tests#create', as: 'create_test'

end
