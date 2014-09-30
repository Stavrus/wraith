# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140721181831) do

  create_table "antiviri", force: true do |t|
    t.integer  "match_id",      null: false
    t.integer  "match_user_id"
    t.string   "uid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "antiviri", ["match_id"], name: "index_antiviri_on_match_id"
  add_index "antiviri", ["match_user_id", "match_id"], name: "index_antiviri_on_match_user_id_and_match_id"
  add_index "antiviri", ["match_user_id"], name: "index_antiviri_on_match_user_id"
  add_index "antiviri", ["uid", "match_id"], name: "index_antiviri_on_uid_and_match_id", unique: true
  add_index "antiviri", ["uid"], name: "index_antiviri_on_uid"

  create_table "badge_users", force: true do |t|
    t.integer  "badge_id",   null: false
    t.integer  "user_id",    null: false
    t.integer  "match_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badge_users", ["badge_id", "match_id"], name: "index_badge_users_on_badge_id_and_match_id"
  add_index "badge_users", ["badge_id"], name: "index_badge_users_on_badge_id"
  add_index "badge_users", ["match_id"], name: "index_badge_users_on_match_id"
  add_index "badge_users", ["user_id", "badge_id", "match_id"], name: "index_badge_users_on_user_id_and_badge_id_and_match_id", unique: true
  add_index "badge_users", ["user_id", "match_id"], name: "index_badge_users_on_user_id_and_match_id"
  add_index "badge_users", ["user_id"], name: "index_badge_users_on_user_id"

  create_table "badges", force: true do |t|
    t.string   "name",                          null: false
    t.text     "description"
    t.integer  "badge_users_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clan_invites", force: true do |t|
    t.integer  "clan_id",                    null: false
    t.integer  "user_id",                    null: false
    t.integer  "sender_id",                  null: false
    t.boolean  "pending",    default: true
    t.boolean  "accepted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clan_invites", ["clan_id", "pending"], name: "index_clan_invites_on_clan_id_and_pending"
  add_index "clan_invites", ["clan_id"], name: "index_clan_invites_on_clan_id"
  add_index "clan_invites", ["sender_id"], name: "index_clan_invites_on_sender_id"
  add_index "clan_invites", ["user_id", "pending"], name: "index_clan_invites_on_user_id_and_pending"
  add_index "clan_invites", ["user_id"], name: "index_clan_invites_on_user_id"

  create_table "clan_users", force: true do |t|
    t.integer  "clan_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "date_join",  null: false
    t.datetime "date_left"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clan_users", ["clan_id"], name: "index_clan_users_on_clan_id"
  add_index "clan_users", ["user_id", "clan_id"], name: "index_clan_users_on_user_id_and_clan_id"
  add_index "clan_users", ["user_id"], name: "index_clan_users_on_user_id"

  create_table "clans", force: true do |t|
    t.integer  "users_count",               default: 0,     null: false
    t.string   "name",                                      null: false
    t.text     "description"
    t.string   "avatar"
    t.string   "avatar_pending"
    t.boolean  "avatar_approval_requested", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_users", force: true do |t|
    t.string   "uid",                         null: false
    t.integer  "token_rank",  default: 1
    t.integer  "match_id",                    null: false
    t.integer  "user_id",                     null: false
    t.integer  "team_id",     default: 1,     null: false
    t.boolean  "waiver",      default: false
    t.boolean  "bandanna",    default: false
    t.boolean  "printed",     default: false
    t.boolean  "oz_interest", default: false
    t.boolean  "oz",          default: false
    t.integer  "tags_count",  default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "match_users", ["match_id", "waiver", "bandanna", "printed"], name: "index_match_playable"
  add_index "match_users", ["match_id"], name: "index_match_users_on_match_id"
  add_index "match_users", ["uid", "match_id"], name: "index_match_users_on_uid_and_match_id", unique: true
  add_index "match_users", ["user_id", "match_id"], name: "index_match_users_on_user_id_and_match_id", unique: true
  add_index "match_users", ["user_id"], name: "index_match_users_on_user_id"

  create_table "matches", force: true do |t|
    t.datetime "date_start",                 null: false
    t.datetime "date_end",                   null: false
    t.string   "title"
    t.text     "reginfo"
    t.boolean  "active",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", force: true do |t|
    t.datetime "date_release", null: false
    t.integer  "team_id",      null: false
    t.integer  "match_id",     null: false
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "missions", ["match_id", "team_id"], name: "index_missions_on_match_id_and_team_id"

  create_table "roles", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true

  create_table "tags", force: true do |t|
    t.integer  "source_id",  null: false
    t.integer  "target_id",  null: false
    t.integer  "match_id",   null: false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["match_id"], name: "index_tags_on_match_id"
  add_index "tags", ["source_id", "match_id"], name: "index_tags_on_source_id_and_match_id"
  add_index "tags", ["source_id"], name: "index_tags_on_source_id"

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true

  create_table "tier_options", force: true do |t|
    t.integer  "tier_id",    null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tier_options", ["tier_id", "name"], name: "index_tier_options_on_tier_id_and_name", unique: true
  add_index "tier_options", ["tier_id"], name: "index_tier_options_on_tier_id"

  create_table "tiers", force: true do |t|
    t.integer  "match_id",     null: false
    t.integer  "team_id",      null: false
    t.string   "name"
    t.text     "description"
    t.datetime "date_release", null: false
    t.datetime "date_end",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tiers", ["match_id", "team_id"], name: "index_tiers_on_match_id_and_team_id"
  add_index "tiers", ["match_id"], name: "index_tiers_on_match_id"

  create_table "tokens", force: true do |t|
    t.string   "uid",                          null: false
    t.integer  "match_id",                     null: false
    t.integer  "match_user_id",                null: false
    t.integer  "rank",          default: 1,    null: false
    t.boolean  "usable",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["match_user_id", "rank"], name: "index_tokens_on_match_user_id_and_rank", unique: true
  add_index "tokens", ["uid", "match_id"], name: "index_tokens_on_uid_and_match_id", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "avatar_pending"
    t.boolean  "avatar_approval_requested", default: false
    t.integer  "role_id",                                   null: false
    t.integer  "clan_id"
    t.string   "email",                     default: "",    null: false
    t.string   "provider"
    t.string   "uid",                       default: "",    null: false
    t.string   "authentication_token"
    t.datetime "auth_expires"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["clan_id"], name: "index_users_on_clan_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.integer  "cached_votes_total", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
