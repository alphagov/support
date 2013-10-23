class CreateLongFormContactsTable < ActiveRecord::Migration
  def change
    create_table :long_form_contacts do |t|
      t.text    :details 
      t.text    :link
      t.string  :user_agent
      t.boolean :javascript_enabled
      t.string  :referrer

      t.timestamps
    end
  end
end
