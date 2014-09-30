class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Profile
      t.string :name
      t.string :avatar
      t.string :avatar_pending
      t.boolean :avatar_approval_requested, default: false

      ## Misc.
      t.integer :role_id, null: false
      t.integer :clan_id

      ## Omniauth
      t.string :email, null: false, default: ""
      t.string :provider
      t.string :uid, null: false, default: ""
      t.string :authentication_token
      t.datetime :auth_expires

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps

      t.index :email, unique: true
      t.index :uid, unique: true
      t.index :clan_id
    end

    create_table(:roles) do |t|
      t.string :name, null: false

      t.timestamps

      t.index :name, unique: true
    end

    create_table(:matches) do |t|
      t.datetime :date_start, null: false
      t.datetime :date_end, null: false

      t.string :title
      t.text :reginfo
      t.boolean :active, default: false

      t.timestamps
    end

    create_table(:match_users) do |t|
      t.string  :uid,        null: false
      t.integer :token_rank, default: 1

      t.integer :match_id, null: false
      t.integer :user_id,  null: false
      t.integer :team_id,  null: false, default: 1

      t.boolean :waiver,   default: false
      t.boolean :bandanna, default: false
      t.boolean :printed,  default: false

      t.boolean :oz_interest, default: false
      t.boolean :oz,          default: false

      t.integer :tags_count, null: false, default: 0

      t.timestamps

      t.index :user_id
      t.index :match_id
      t.index [:uid, :match_id], unique: true
      t.index [:user_id, :match_id], unique: true
      t.index [:match_id, :waiver, :bandanna, :printed], name: 'index_match_playable'
    end

    create_table(:teams) do |t|
      t.string :name, null: false

      t.timestamps

      t.index :name, unique: true
    end

    create_table(:tags) do |t|
      t.integer :source_id, null: false
      t.integer :target_id, null: false
      t.integer :match_id,  null: false

      t.float :latitude
      t.float :longitude

      t.timestamps

      t.index :source_id
      t.index :match_id
      t.index [:source_id, :match_id]
    end

    create_table(:tokens) do |t|
      t.string :uid, null: false

      t.integer :match_id,      null: false
      t.integer :match_user_id, null: false

      t.integer :rank, null: false, default: 1
      t.boolean :usable, default: true

      t.timestamps

      t.index [:uid, :match_id], unique: true
      t.index [:match_user_id, :rank], unique: true
    end

    create_table(:missions) do |t|
      t.datetime :date_release, null: false

      t.integer :team_id,  null: false
      t.integer :match_id, null: false

      t.string :title
      t.text   :description

      t.timestamps

      t.index [:match_id, :team_id]
    end

    create_table(:antiviri) do |t|
      t.integer :match_id, null: false
      t.integer :match_user_id # If null, it's unused

      t.string :uid
      t.text   :description

      t.timestamps

      t.index :uid
      t.index :match_id
      t.index :match_user_id
      t.index [:uid, :match_id], unique: true
      t.index [:match_user_id, :match_id]
    end

    create_table(:votes) do |t|
      t.references :votable, polymorphic: true
      t.references :voter, polymorphic: true

      t.boolean :vote_flag
      t.string :vote_scope
      t.integer :vote_weight

      t.integer :cached_votes_total, null: false, default: 0

      t.timestamps
    end

    if ActiveRecord::VERSION::MAJOR < 4
      add_index :votes, [:votable_id, :votable_type]
      add_index :votes, [:voter_id, :voter_type]
    end

    add_index :votes, [:voter_id, :voter_type, :vote_scope]
    add_index :votes, [:votable_id, :votable_type, :vote_scope]

    create_table(:tiers) do |t|
      t.integer :match_id, null: false
      t.integer :team_id,  null: false

      t.string   :name
      t.text     :description
      t.datetime :date_release, null: false
      t.datetime :date_end,     null: false

      t.timestamps

      t.index :match_id
      t.index [:match_id, :team_id]
    end

    create_table(:tier_options) do |t|
      t.integer :tier_id, null: false

      t.string :name, null: false

      t.timestamps

      t.index :tier_id
      t.index [:tier_id, :name], unique: true
    end

    create_table(:clans) do |t|
      t.integer :users_count, null: false, default: 0

      t.string :name, unique: true, null: false
      t.text   :description
      t.string :avatar
      t.string :avatar_pending
      t.boolean :avatar_approval_requested, default: false

      t.timestamps
    end

    # Keeps track of clan user history
    create_table(:clan_users) do |t|
      t.integer :clan_id, null: false
      t.integer :user_id, null: false

      t.datetime :date_join, null: false
      t.datetime :date_left

      t.timestamps

      t.index :clan_id
      t.index :user_id
      t.index [:user_id, :clan_id]
    end

    create_table(:clan_invites) do |t|
      t.integer :clan_id, null: false
      t.integer :user_id, null: false
      t.integer :sender_id, null: false

      t.boolean :pending, default: true
      t.boolean :accepted, default: false

      t.timestamps

      t.index :clan_id
      t.index :user_id
      t.index :sender_id
      t.index [:user_id, :pending]
      t.index [:clan_id, :pending]
    end

    create_table(:badges) do |t|
      t.string :name, null: false
      t.text   :description

      t.integer :badge_users_count, null: false, default: 0

      t.timestamps
    end

    create_table(:badge_users) do |t|
      t.integer :badge_id, null: false
      t.integer :user_id,  null: false
      t.integer :match_id, null: false

      t.timestamps

      t.index :badge_id
      t.index :user_id
      t.index :match_id
      t.index [:badge_id, :match_id]
      t.index [:user_id, :match_id]
      t.index [:user_id, :badge_id, :match_id], unique: true
    end

  end
end
