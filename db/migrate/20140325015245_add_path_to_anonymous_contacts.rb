class AddPathToAnonymousContacts < ActiveRecord::Migration
  def change
    add_column :anonymous_contacts, :path, :text
  end
end
