# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171224213754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.string "name"
    t.integer "power"
    t.integer "units"
    t.integer "unit_health"
    t.integer "speed"
    t.integer "movement_type"
    t.integer "game_turn"
    t.integer "health"
    t.boolean "moved"
    t.boolean "attacked"
    t.bigint "tile_id"
    t.index ["team_id"], name: "index_characters_on_team_id"
    t.index ["tile_id"], name: "index_characters_on_tile_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
    t.integer "character_turn", default: 0
  end

  create_table "players", force: :cascade do |t|
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_players_on_character_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "game_id"
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "tiles", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "x_position"
    t.integer "y_position"
    t.boolean "walkable", default: true
    t.index ["game_id"], name: "index_tiles_on_game_id"
  end

end
