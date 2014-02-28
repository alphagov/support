class AddUserSpecifiedLinkToAnonymousFeedback < ActiveRecord::Migration
  def change
    add_column :anonymous_contacts, :user_specified_url, :text
  end
end
