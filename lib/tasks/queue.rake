namespace :jobs do
  task :work do
    exec("bundle exec sidekiq")
  end
end