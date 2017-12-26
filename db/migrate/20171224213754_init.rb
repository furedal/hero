class Init < ActiveRecord::Migration[5.1]
	def change
		create_table :tiles do |t|
			t.references :game
			t.integer :x_position
			t.integer :y_position
			t.boolean :walkable, default: true
		end

		create_table :games do |t|
			t.integer :width
			t.integer :height
			t.integer :character_turn, default: 0
		end

		create_table :teams do |t|
			t.references :game
		end

		create_table :characters do |t|
			t.timestamps
			t.references :team
			t.string :name
			t.integer :power
			t.integer :units
			t.integer :unit_health
			t.integer :speed
			t.integer :movement_type

			t.integer :game_turn
			t.integer :health
			t.boolean :moved
			t.boolean :attacked

			t.references :tile
		end

		create_table :players do |t|
			t.references :character
			t.timestamps
		end

	end
end
