class NullifyEmptyServiceFeedbackComments < ActiveRecord::Migration
  class AnonymousContact < ActiveRecord::Base; end

  def up
    AnonymousContact.where(details: "").update_all(details: nil)
  end
end
