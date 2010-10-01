Radiator::Application.routes do  
  resources :betabrite, :co llection => { :radiate => :get }

  root :controller => :betabrite   
end
