class MoveAllUserSpecifiedLinksForLongFormFeedback < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts
                                              SET user_specified_link = url
                                            WHERE type = 'Support::Requests::Anonymous::LongFormContact'
                                              AND url IS NOT NULL")
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts
                                              SET url = '#{Plek.new.website_root}/contact/govuk'
                                            WHERE type = 'Support::Requests::Anonymous::LongFormContact'")
  end

  def down
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts
                                              SET url = NULL
                                            WHERE type = 'Support::Requests::Anonymous::LongFormContact'")
    ActiveRecord::Base.connection.execute("UPDATE anonymous_contacts
                                              SET url = user_specified_link
                                            WHERE type = 'Support::Requests::Anonymous::LongFormContact'
                                              AND user_specified_link IS NOT NULL")

  end
end
