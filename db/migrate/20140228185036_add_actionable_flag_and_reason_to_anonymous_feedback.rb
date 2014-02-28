class AddActionableFlagAndReasonToAnonymousFeedback < ActiveRecord::Migration
  def change
    add_column :anonymous_contacts, :is_actionable, :boolean, default: true
    add_column :anonymous_contacts, :reason_why_not_actionable, :string
  end
end
