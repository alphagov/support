desc "Run linters"
task lint: :environment do
  sh "bundle exec rubocop"
  sh "yarn install"
  sh "yarn run lint"
end
