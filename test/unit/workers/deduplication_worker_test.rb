require 'test_helper'

class DeduplicationWorkerTest < ActiveSupport::TestCase
  include Support::Requests::Anonymous

  should "remove duplicate anonymous feedback for yesterday" do
    Date.stubs(:yesterday).returns(Date.new(2013,2,10))

    AnonymousContact.
      expects(:deduplicate_contacts_created_between).
      with(Date.new(2013,2,10).beginning_of_day..Date.new(2013,2,10).end_of_day)

    DeduplicationWorker.run
  end
end
