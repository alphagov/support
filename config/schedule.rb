# default cron env is "/usr/bin:/bin" which is not sufficient as govuk_env is in /usr/local/bin
env :PATH, '/usr/local/bin:/usr/bin:/bin'

set :output, {:error => 'log/cron.error.log', :standard => 'log/cron.log'}

# We need Rake to use our own environment
job_type :rake, "cd :path && govuk_setenv signon bundle exec rake :task :output"

every 1.day, :at => '12:30 am' do
  rake "push_service_feedback_to_pp"
end
