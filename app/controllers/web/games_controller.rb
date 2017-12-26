class Web::GamesController < ApplicationController
    def show
        @id = params['id']
        render 'games/index'
    end

    private
    def current_game
        Game.find(params['id'])
    end

    def current_character
        current_game.characters.find(params['character_id'])
    end
end
