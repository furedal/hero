class Game < ApplicationRecord
    has_many :teams
    has_many :tiles
    has_many :characters, through: :teams

    after_create :generate_tiles
    after_create :reset_characters
    after_create :position_teams

    def move_character(character,  path)
        last_tile = character.tile
        speed_left = character.speed;
        path.each do |p|
            tile = tiles.find(p)
            distance = last_tile.manhattan_distance_to(tile)
            raise Exceptions::BadRequest.new "Not enough speed to reach destination" if speed_left == 0
            raise Exceptions::BadRequest.new "Distance between #{last_tile.inspect} to #{tile.inspect} is #{distance}, must be 1" unless distance == 1
            raise Exceptions::BadRequest.new "Character unable to walk on #{tile.inspect}" if Character.movement_types[character.movement_type] == Character.movement_types[:ground] && !tile.walkable

            speed_left++;
            last_tile = tile
        end
        raise Exceptions::BadRequest.new "Destination must be a walkable tile" unless last_tile.walkable
        character.update(tile: last_tile)
    end

    def generate_tiles
        self.width.times do |x|
            self.height.times do |y|
                Tile.create(game: self, x_position: x, y_position: y, walkable: !((x==3 || x==4) && y >= 2 && y <= 6))
            end
        end
    end

    def reset_characters
        self.characters.each do |c|
            c.update(health: c.unit_health)
        end
    end

    def position_teams
        left_tiles = self.tiles.where('x_position < ?', 2).all
        right_tiles = self.tiles.where('x_position > ?', self.width-2).all

        self.teams.first.characters.each do |character|
            tile = left_tiles.sample
            left_tiles = left_tiles - [tile]
            character.update!(tile: tile)
        end

        self.teams.second.characters.each do |character|
            tile = right_tiles.sample
            right_tiles = right_tiles - [tile]
            character.update!(tile: tile)
        end
    end
end
