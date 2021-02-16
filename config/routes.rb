Rails.application.routes.draw do
  scope do
    namespace :v1 do
      resources :tweets, only: %i[create]
    end
  end
end
