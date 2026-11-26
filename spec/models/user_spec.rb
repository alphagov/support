require "rails_helper"
require "govuk_redis_client"

require "gds-sso/lint/user_spec"

describe User, type: :model do
  context "when storing the user in Redis as JSON" do
    it "updates an attribute that already exists when given a Symbol key" do
      user = User.upsert!("uid" => "12345", "name" => "A", "email" => "a@b.com")
      user.update_attribute(:name, "B")

      expect(User::Store.fetch("12345")).to eq("uid" => "12345", "name" => "B", "email" => "a@b.com")
      expect(User.where(uid: "12345").first.name).to eq("B")
    end

    it "keeps a user readable after they sign in and are then remotely signed out" do
      user = User.upsert!("uid" => "12345", "name" => "A", "email" => "a@b.com")
      user.clear_remotely_signed_out!
      user.set_remotely_signed_out!

      expect(User::Store.fetch("12345")).to include("remotely_signed_out" => true)
      expect(User.where(uid: "12345", remotely_signed_out: true)).not_to be_empty
      expect(User.where(uid: "12345", remotely_signed_out: false)).to be_empty
    end

    it "normalises Symbol and String keys before writing, so they cannot produce a duplicate JSON key" do
      User::Store.write("12345", { "uid" => "12345", "remotely_signed_out" => false, remotely_signed_out: true })

      expect(User::Store.fetch("12345")).to eq("uid" => "12345", "remotely_signed_out" => true)
    end
  end

  it "supports persistent creation and retrieval" do
    expect(User.where(uid: "12345")).to be_empty
    User.upsert!("uid" => "12345", "name" => "A", "email" => "a@b.com")

    u = User.where(uid: "12345").first
    expect(u).to_not be_nil
    expect(u.name).to eq("A")
    expect(u.email).to eq("a@b.com")
  end

  it "supports remote sign-out" do
    user = User.upsert!("uid" => "12345", "name" => "A", "email" => "a@b.com")
    expect(user).to_not be_remotely_signed_out

    user.update_attribute(:remotely_signed_out, true)
    expect(user).to be_remotely_signed_out

    expect(User.where(uid: "12345", remotely_signed_out: false)).to be_empty
  end

  it "supports mass updating of attributes" do
    user = User.upsert!("uid" => "12345", "name" => "A", "email" => "a@b.com")
    user.update!({ "uid" => "12345", "name" => "Z", "email" => "x@y.com" }, as: :somebody)

    expect(user.name).to eq("Z")
    expect(user.email).to eq("x@y.com")

    expect(User.where(uid: "12345").first.name).to eq("Z")
  end

  it_behaves_like "a gds-sso user class"
end
