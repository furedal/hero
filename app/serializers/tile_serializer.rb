class TileSerializer < ActiveModel::Serializer
  attributes :id, :x_position, :y_position, :walkable
end
