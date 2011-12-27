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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111108231310) do

  create_table "admin_accounts", :force => true do |t|
    t.string   "host"
    t.integer  "idle_timeout"
    t.integer  "session_timeout"
    t.integer  "setting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_accounts", ["setting_id"], :name => "index_admin_accounts_on_setting_id"

  create_table "admin_settings", :force => true do |t|
    t.string   "assertion_consumer_service_url"
    t.string   "assertion_consumer_service_binding"
    t.string   "single_logout_service_url"
    t.string   "single_logout_service_binding"
    t.string   "idp_metadata"
    t.integer  "idp_metadata_ttl"
    t.string   "name_identifier_format"
    t.string   "issuer"
    t.string   "authn_context"
    t.string   "idp_cert_fingerprint"
    t.string   "idp_sso_target_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stuffs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
