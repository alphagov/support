require 'test_helper'

class TechnicalFaultReportTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
end