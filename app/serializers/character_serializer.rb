class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :units, :health, :unit_health, :power, :speed, :movement_type, :game_turn
  belongs_to :tile

end