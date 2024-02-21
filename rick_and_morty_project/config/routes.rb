Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      scope '/rick_and_morty' do
        get '/locations' => 'locations#index'
        get '/locations/:id' => 'locations#show'
        get '/characters' => 'characters#index'
        get '/characters/:id' => 'characters#show'
        
        scope '/scenes' do
          get '/' => 'scenes#index'
          get '/:id' => 'scenes#show'
          post '/' => 'scenes#create'
          delete '/:id' => 'scenes#destroy'
        end
      end

      scope '/histories' do
        get '/' => 'histories#index'
        post '/' => 'histories#create'
        get '/:id' => 'histories#show'
        put '/:id' => 'histories#update'
        delete '/:id' => 'histories#destroy'
      end
    end
  end
end
