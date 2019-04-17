desc 'Run govuk-lint-ruby on all files'
task :lint do
  system 'govuk-lint-ruby --parallel app spec lib Gemfile'
end
