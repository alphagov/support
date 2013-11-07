class AddServiceFeedbackFieldsToAnonymousContactsTable < ActiveRecord::Migration
  def change
    add_column :anonymous_contacts, :slug, :string
    add_column :anonymous_contacts, :service_satisfaction_rating, :integer
  end
end
