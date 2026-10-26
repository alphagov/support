require "rails_helper"

describe "config/initializers/gds_sso.rb" do
  around do |example|
    original_strategy = ENV["GDS_SSO_STRATEGY"]
    example.run
  ensure
    ENV["GDS_SSO_STRATEGY"] = original_strategy
    GDS::SSO.test_user = nil
  end

  def load_initializer_in(rails_env)
    allow(Rails).to receive(:env).and_return(ActiveSupport::EnvironmentInquirer.new(rails_env))
    GDS::SSO.test_user = nil
    load Rails.root.join("config/initializers/gds_sso.rb")
  end

  it "signs in as a dummy user in development" do
    ENV.delete("GDS_SSO_STRATEGY")
    load_initializer_in("development")

    expect(GDS::SSO.test_user.uid).to eq("dummy-user")
  end

  it "signs in as a dummy user in production when gds-sso's mock strategy is used" do
    ENV["GDS_SSO_STRATEGY"] = "mock"
    load_initializer_in("production")

    expect(GDS::SSO.test_user.uid).to eq("dummy-user")
  end

  it "doesn't sign in as a dummy user in production otherwise" do
    ENV.delete("GDS_SSO_STRATEGY")
    load_initializer_in("production")

    expect(GDS::SSO.test_user).to be_nil
  end
end
