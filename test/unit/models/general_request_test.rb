require 'test_helper'

class GeneralRequestTest < Test::Unit::TestCase
  should validate_presence_of(:requester)

  should allow_value("http://www.gov.uk").for(:url)

  should allow_value("a comment").for(:additional)
end