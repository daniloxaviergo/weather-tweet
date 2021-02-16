Rails.application.routes.draw do
  apipie
  scope do
    namespace :v1 do
      resources :tweets, only: %i[create]
    end
  end
end
