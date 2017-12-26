class Api::V1::TeamsController < ApplicationController
    def index
        team = Team.all
        render json: team
    end
end
