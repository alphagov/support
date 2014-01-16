desc "Trigger an upload of service feedback data to the performance platform"
task :push_service_feedback_to_pp => :environment do
  require File.join(Rails.root, 'app', 'workers', 'service_feedback_pp_uploader_worker')
  require 'volatile_lock'

  if VolatileLock.new('support:push_service_feedback_to_pp').obtained?
    ServiceFeedbackPPUploaderWorker.run
    puts "ServiceFeedbackPPUploaderWorker invoked"
  else
    puts "ServiceFeedbackPPUploaderWorker: skipping, couldn't obtain lock (probably the task has already run on another node"
  end
end
