Radiator::Application.routes do  
  resources :betabrite, :collection => { :radiate => :get }

  root :controller => :betabrite   
end
