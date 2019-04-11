class SheetsRequester
  APPLICATION_NAME = 'Managing Smart Survey Feedback'.freeze
  attr_reader :service
  def initialize(auth_client)
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = auth_client
  end

  def get_sheet_values(spreadsheet_id, range)
    @service.get_spreadsheet_values(spreadsheet_id, range)
  end
end
