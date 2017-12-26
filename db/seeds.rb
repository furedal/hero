DatabaseCleaner.clean_with(:truncation) unless Rails.env.production?



team1 = Team.create!()
Character.create!(name: 'Character1', team: team1, units: 5, power: 10, unit_health: 100, speed: 8, movement_type: :ground)
Character.create!(name: 'Character2', team: team1, units: 10, power: 20, unit_health: 100, speed: 3, movement_type: :ground)

team2 = Team.create!()
Character.create!(name: 'Character3', team: team2, units: 5, power: 10, unit_health: 100, speed: 8, movement_type: :ground)
Character.create!(name: 'Character4', team: team2, units: 10, power: 20, unit_health: 100, speed: 3, movement_type: :ground)

game = Game.create!(width: 8, height: 8, teams: [team1, team2])


