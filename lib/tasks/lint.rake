desc "Run rubocop on all files"
task lint: :environment do
  system "rubocop --parallel app spec lib Gemfile"
end
