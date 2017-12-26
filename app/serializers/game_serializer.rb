class GameSerializer < ActiveModel::Serializer
  attributes :id, :width, :height
  has_many :teams
  has_many :tiles

end
