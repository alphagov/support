require 'support/requests/anonymous/anonymous_contact'

class DeduplicationWorker
  include Sidekiq::Worker
  include Support::Requests::Anonymous

  def perform(year, month, day)
    logger.info("Deduping anonymous feedback for #{year}-#{month}-#{day}")
    day = Date.new(year, month, day)

    AnonymousContact.deduplicate_contacts_created_between(day.beginning_of_day..day.end_of_day)
  end

  def self.run
    yesterday = Date.yesterday
    perform_async(yesterday.year, yesterday.month, yesterday.day)
    logger.info("Deduplication scheduled for anonymous feedback created on #{yesterday}")
  end
end
