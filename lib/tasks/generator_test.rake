namespace :test do
  Rake::TestTask.new("generators") do |t|
    t.libs << "test"
    t.test_files = FileList['test/generators/**/*_test.rb']
    t.verbose = true
  end
end

task :test => "test:generators"