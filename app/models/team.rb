class Team < ApplicationRecord
    belongs_to :game, optional: true
    has_many :characters
end
