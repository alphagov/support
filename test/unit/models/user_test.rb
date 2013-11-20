require 'test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    Rails.cache.clear
  end

  def teardown
    Rails.cache.clear
  end

  should "support persistent creation and retrieval" do
    assert User.where(uid: "12345").empty?
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")

    u = User.where(uid: "12345").first
    assert_not_nil u
    assert_equal "A", u.name
    assert_equal "a@b.com", u.email
  end

  should "support remote sign-out" do
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")
    refute user.remotely_signed_out?

    user.update_attribute(:remotely_signed_out, true)
    assert user.remotely_signed_out?

    assert User.where(uid: "12345").first.remotely_signed_out?
  end

  should "support mass updating of attributes" do
    user = User.create!("uid" => "12345", "name" => "A", "email" => "a@b.com")

    user.update_attributes({ "uid" => "12345", "name" => "Z", "email" => "x@y.com" }, { as: :somebody })

    assert_equal "Z", user.name
    assert_equal "x@y.com", user.email

    assert_equal "Z", User.where(uid: "12345").first.name
  end
end