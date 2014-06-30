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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140630065039) do

  create_table "anonymous_contacts", :force => true do |t|
    t.string   "type"
    t.text     "what_doing"
    t.text     "what_wrong"
    t.text     "details"
    t.string   "source"
    t.string   "page_owner"
    t.text     "url"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "javascript_enabled"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "personal_information_status"
    t.string   "slug"
    t.integer  "service_satisfaction_rating"
    t.text     "user_specified_url"
    t.boolean  "is_actionable",               :default => true, :null => false
    t.string   "reason_why_not_actionable"
    t.text     "path"
  end

end
