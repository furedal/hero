class Tile < ApplicationRecord
    belongs_to :game

    def manhattan_distance_to(tile)
        (self.x_position - tile.x_position).abs + (self.y_position - tile.y_position).abs
    end
end
