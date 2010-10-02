Radiator::Application.routes.draw do  
  
  resources :messages do
    collection do
      post :clear
    end
  end
  
  root :to => "messages#index"   
end
