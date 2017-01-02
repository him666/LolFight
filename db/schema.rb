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

ActiveRecord::Schema.define(version: 20161229223558) do

  create_table "champions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "game_num"
    t.text     "tags",        limit: 65535
    t.text     "stats",       limit: 65535
    t.text     "block_items", limit: 65535
    t.string   "basic_dmg"
    t.text     "passive",     limit: 65535
    t.text     "lore",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "game_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "pro_player_id"
    t.integer  "champion_num"
    t.string   "champion"
    t.integer  "minions"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
    t.integer  "dragons"
    t.integer  "wards"
    t.integer  "vision"
    t.integer  "dmg_dealt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["pro_player_id"], name: "index_game_stats_on_pro_player_id", using: :btree
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "tags",        limit: 65535
    t.integer  "game_num"
    t.text     "description", limit: 65535
    t.text     "plaintext",   limit: 65535
    t.text     "stats",       limit: 65535
    t.string   "name"
    t.integer  "gold"
    t.integer  "sell_price"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "masteries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "game_num"
    t.string   "ranks"
    t.text     "description",  limit: 65535
    t.string   "name"
    t.text     "mastery_tree", limit: 65535
    t.string   "modifier"
    t.string   "mod_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "pro_players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "game_num"
    t.string   "tier"
    t.text     "rank",        limit: 65535
    t.integer  "games"
    t.string   "most_played"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "runes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "description", limit: 65535
    t.string   "name"
    t.text     "tags",        limit: 65535
    t.integer  "game_num"
    t.string   "type2"
    t.string   "tier"
    t.text     "stats",       limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "spells", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "base_dmg",    limit: 65535
    t.text     "cooldown",    limit: 65535
    t.text     "bonus_dmg",   limit: 65535
    t.string   "effect"
    t.text     "description", limit: 65535
    t.integer  "champion_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["champion_id"], name: "index_spells_on_champion_id", using: :btree
  end

  create_table "sum_spells", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "game_num"
    t.text     "description",    limit: 65535
    t.string   "name"
    t.string   "gkey"
    t.string   "buff"
    t.string   "percent_or_num"
    t.string   "cooldown"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "tips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "atip",        limit: 65535
    t.text     "btip",        limit: 65535
    t.integer  "champion_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["champion_id"], name: "index_tips_on_champion_id", using: :btree
  end

  add_foreign_key "game_stats", "pro_players"
  add_foreign_key "spells", "champions"
  add_foreign_key "tips", "champions"
end
