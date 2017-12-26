Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :web do
        resources :games, only: [:index, :show]
  end

  namespace :api do
        namespace :v1 do
            resources :teams, only: [:index]
            resources :characters, only: [:index]
            resources :games, only: [:index, :show] do
                member do
                    put    'characters/:character_id/move',           to: 'games#move_character'
                    put    'characters/:character_id/attack',         to: 'games#attack_character'
                end
            end
        end
    end
end
