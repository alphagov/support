class CreateProblemReportsTable < ActiveRecord::Migration
  def change
    create_table :problem_reports do |t|
      t.text    :what_doing 
      t.text    :what_wrong
      t.string  :url
      t.string  :user_agent
      t.boolean :javascript_enabled
      t.string  :referrer
      t.string  :source
      t.string  :page_owner

      t.timestamps
    end
  end
end
