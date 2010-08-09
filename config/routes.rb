ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  map.resources :betabrite, :collection => { :radiate => :get }
  
  map.connect 'continuous_integration/radiate/:project/:status', :controller => 'continuous_integration', :action => 'radiate'
  map.connect 'continuous_integration/dim/:project', :controller => 'continuous_integration', :action => 'dim'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => :betabrite

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
