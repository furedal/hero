class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :units, :health, :unit_health, :power, :speed, :movement_type
  belongs_to :tile

end