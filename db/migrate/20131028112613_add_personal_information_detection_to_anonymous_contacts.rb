class AddPersonalInformationDetectionToAnonymousContacts < ActiveRecord::Migration
  def change
    add_column :anonymous_contacts, :personal_information_status, :string
  end
end
