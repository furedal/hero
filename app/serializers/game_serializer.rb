class GameSerializer < ActiveModel::Serializer
  attributes :id, :width, :height, :character_turn
  has_many :teams
  has_many :tiles

end
