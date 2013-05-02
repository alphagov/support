desc "Create a default user allowing running in GDS-SSO mock mode"
namespace :users do
  task :create_dummy => :environment do
    user = User.create!(
      "uid" => 'dummy-user',
      "name" => 'Ms Example',
      "email" => 'example@example.com',
      "permissions" => ['signon']
    )
    puts "Created dummy user: #{user}"
  end
end