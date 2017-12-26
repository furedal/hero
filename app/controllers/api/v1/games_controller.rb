class Api::V1::GamesController < ApplicationController

    def index
        render json: Game.all, include: '**'
    end

    def show
        render json: current_game, include: '**'
    end

    def move_character
        path = params['path']
        current_game.move_character(current_character, path)
        render json: current_character
    end

    def attack_character
        character = current_game.characters.find(character_params['id'])
        current_character.attack(character)
        render json: character
    end

    private

    def character_params
        params.require('character').permit('id')
    end

    def current_game
        Game.find(params['id'])
    end

    def current_character
        current_game.characters.find(params['character_id'])
    end
end
