desc "Start the sidekiq workers"
namespace :jobs do
  task :work do
    exec("bundle exec sidekiq -C ./config/sidekiq.yml")
  end
end
