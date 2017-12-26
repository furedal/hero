class Api::V1::GamesController < ApplicationController

    before_action :check_character_turn, only: [:move_character, :attack_character, :finish_turn]

    def index
        render json: Game.all, include: '**'
    end

    def show
        render json: current_game, include: '**'
    end

    def finish_turn
        current_game.finish_turn
        render json: current_game
    end

    def move_character
        raise Exceptions::BadRequest.new "This character has already moved" if current_character.moved
        path = params['path']
        current_game.move_character(current_character, path)
        render json: current_character
    end

    def attack_character
        raise Exceptions::BadRequest.new "This character has already attacked" if current_character.attacked
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

    def check_character_turn
        raise Exceptions::BadRequest.new "Not this characters turn" unless current_character == current_game.current_character
    end
end
