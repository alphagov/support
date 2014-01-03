desc "Trigger an upload of service feedback data to the performance platform"
task :push_service_feedback_to_pp => :environment do
  require File.join(Rails.root, 'app', 'workers', 'service_feedback_pp_uploader_worker')
  ServiceFeedbackPPUploaderWorker.run
end
