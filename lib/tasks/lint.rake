desc "Run rubocop on all files"
task :lint do
  system "rubocop --parallel app spec lib Gemfile"
end
