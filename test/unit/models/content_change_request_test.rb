require 'test_helper'

class ContentChangeRequestTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
  should validate_presence_of(:details_of_change)

  should validate_presence_of(:request_context)

  should allow_value("xxxx").for(:title)
  should allow_value(nil).for(:title)
  
  should allow_value("https://www.gov.uk").for(:url)
  should allow_value("https://www.gov.uk/A\nhttps://www.gov.uk/A").for(:related_urls)

  should "allow time constraints" do
    request = ContentChangeRequest.new(:time_constraint => stub("time constraint", :valid? => true))
    request.valid?
    assert_equal 0, request.errors[:time_constraint].size
  end
end