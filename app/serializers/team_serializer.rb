class TeamSerializer < ActiveModel::Serializer
  attributes :id
  has_many :characters
end
