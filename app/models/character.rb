class Character < ApplicationRecord
    belongs_to :team
    belongs_to :tile, optional: true
    delegate :game, to: :tile
    enum movement_type: { ground: 0, air: 1 }

    def attack(character)
        distance = self.tile.manhattan_distance_to(character.tile)
        raise Exceptions::BadRequest.new "The characters must be next to each other, distance: #{distance}" unless distance == 1
        total_health = character.unit_health * (character.units - 1) + character.health - self.units * self.power
        units = (total_health/character.unit_health).ceil
        character.update!(health: total_health%character.unit_health, units: units)
    end
end
