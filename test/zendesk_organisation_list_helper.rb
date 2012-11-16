module ZendeskOrganisationListHelper
  def stub_zendesk_organisation_list
    url = %r{https://.*@govuk.zendesk.com/api/v2/ticket_fields/21494928}
    body = {
      "ticket_field" => {
        "url" => "https://govuk.zendesk.com/api/v2/ticket_fields/21494928.json",
        "id"=>21494928,
        "type"=>"tagger",
        "title"=>"Department",
        "description"=>"",
        "position"=>9999,
        "active"=>true,
        "required"=>false,
        "collapsed_for_agents"=>false,
        "regexp_for_validation"=>nil,
        "title_in_portal"=>"Department",
        "visible_in_portal"=>false,
        "editable_in_portal"=>false,
        "required_in_portal"=>false,
        "tag"=>nil,
        "created_at"=>"2012-08-07 08:06:33 UTC",
        "updated_at"=>"2012-08-07 08:06:33 UTC",
        "custom_field_options"=>[
          {"name"=>"Advocate General for Scotland", "value"=>"advocate_general_for_scotland"},
          {"name"=>"Attorney General's Office", "value"=>"attorney_generals_office"},
          {"name"=>"Cabinet Office", "value"=>"cabinet_office"}
        ]
      }
    }

    stub_request(:get, url).
      to_return(:status => 200, :body => body.to_json, :headers => {"Content-Type" => "application/json"})
  end
end