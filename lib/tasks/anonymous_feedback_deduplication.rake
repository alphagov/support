desc "Trigger deduplication for yesterday's anonymous feedback"
task :anonymous_feedback_deduplication => :environment do
  require File.join(Rails.root, 'app', 'workers', 'deduplication_worker')
  require 'volatile_lock'

  if VolatileLock.new('support:anonymous_feedback_deduplication').obtained?
    DeduplicationWorker.run
    puts "DeduplicationWorker invoked"
  else
    puts "DeduplicationWorker: skipping, couldn't obtain lock (probably the task has already run on another node)"
  end
end
