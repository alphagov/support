class CreateAnonymousContactsTable < ActiveRecord::Migration
  def change
    create_table :anonymous_contacts do |t|
      t.string  :type

      t.text    :what_doing
      t.text    :what_wrong
      t.text    :details
      t.string  :source
      t.string  :page_owner

      t.text    :url
      t.string  :user_agent
      t.string  :referrer
      t.boolean :javascript_enabled

      t.timestamps
    end
  end
end
