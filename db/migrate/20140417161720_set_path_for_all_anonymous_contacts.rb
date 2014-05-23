class SetPathForAllAnonymousContacts < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE anonymous_contacts
         SET path = REPLACE(url, '#{Plek.new.website_root}', '')
       WHERE path IS NULL
         AND url IS NOT NULL
    SQL
  end
end
