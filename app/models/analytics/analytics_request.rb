require 'shared/tableless_model'
require 'shared/with_requester'
require 'shared/with_request_context'
require 'analytics/needed_report'

class AnalyticsRequest < TablelessModel
  include WithRequester
  include WithRequestContext

  attr_accessor :needed_report, :justification_for_needing_report

  validates_presence_of :needed_report, :justification_for_needing_report

  def needed_report_attributes=(attr)
    self.needed_report = NeededReport.new(attr)
  end

  def self.label
    "Analytics"
  end
end