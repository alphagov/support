class FixServiceFeedbackRecords < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts SET slug = REPLACE(slug,'done/','')")
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts
                                              SET url = CONCAT('#{Plek.new.website_root}/done/', slug)
                                            WHERE type = 'Support::Requests::Anonymous::ServiceFeedback'
                                              AND url is null")
  end
end
