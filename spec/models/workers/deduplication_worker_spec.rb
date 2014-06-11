require 'rails_helper'

describe DeduplicationWorker do
  it "removes duplicate anonymous feedback for yesterday" do
    Timecop.travel Date.new(2013,2,11)

    expect(Support::Requests::Anonymous::AnonymousContact).
      to receive(:deduplicate_contacts_created_between).
      with(Date.new(2013,2,10).beginning_of_day..Date.new(2013,2,10).end_of_day)

    DeduplicationWorker.run
  end
end
