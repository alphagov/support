require 'test/unit'
require 'shoulda/context'
require 'name_guesser'

class NameGuesserTest < Test::Unit::TestCase
  context "given an email with format 'firstname.lastname@host'" do
    should "guess the name as Firstname Lastname" do
      assert_equal "First Last", NameGuesser.new.guess_from_email("first.last@email.com")
    end
  end

  context "given an email which is not 'firstname.lastname@host', e.g. 'abc@host'" do
    should "capitalise the first letter" do
      assert_equal "Abc", NameGuesser.new.guess_from_email("abc@email.com")
    end
  end

  should "handle the case when email is nil" do
    assert_nil NameGuesser.new.guess_from_email(nil)
  end
end