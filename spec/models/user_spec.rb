require 'rails_helper'

describe User, :type => :model do
  before do
    Rails.cache.clear
  end

  after do
    Rails.cache.clear
  end

  it "supports persistent creation and retrieval" do
    expect(User.where(uid: "12345")).to be_empty
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")

    u = User.where(uid: "12345").first
    expect(u).to_not be_nil
    expect(u.name).to eq("A")
    expect(u.email).to eq("a@b.com")
  end

  it "supports remote sign-out" do
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")
    expect(user).to_not be_remotely_signed_out

    user.update_attribute(:remotely_signed_out, true)
    expect(user).to be_remotely_signed_out

    expect(User.where(uid: "12345", remotely_signed_out: false)).to be_empty
  end

  it "supports mass updating of attributes" do
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")

    user.update_attributes({ "uid" => "12345", "name" => "Z", "email" => "x@y.com" }, { as: :somebody })

    expect(user.name).to eq("Z")
    expect(user.email).to eq("x@y.com")

    expect(User.where(uid: "12345").first.name).to eq("Z")
  end
end
