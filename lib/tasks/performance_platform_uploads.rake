namespace :performance_platform_uploads do
  desc "Trigger an upload of problem report stats (grouped by dept) to the performance platform"
  task :push_problem_report_stats => :environment do
    require File.join(Rails.root, 'app', 'workers', 'problem_report_stats_pp_uploader_worker')
    require 'volatile_lock'

    if VolatileLock.new('support:problem_report_stats_to_pp').obtained?
      ProblemReportStatsPPUploaderWorker.run
      puts "ProblemReportStatsPPUploaderWorker invoked"
    else
      puts "ProblemReportStatsPPUploaderWorker: skipping, couldn't obtain lock (probably the task has already run on another node)"
    end
  end
end
