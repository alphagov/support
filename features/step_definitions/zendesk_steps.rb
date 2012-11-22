Then /^the following ticket is raised in ZenDesk:$/ do |ticket_properties_table|
  expected_ticket_props = ticket_properties_table.hashes.first
  @raised_ticket = @zendesk_api.ticket

  assert_equal expected_ticket_props["Subject"],         @raised_ticket.subject
  assert_equal expected_ticket_props["Requester email"], @raised_ticket.email
  assert_equal expected_ticket_props["Requester name"],  @raised_ticket.name
  assert_equal expected_ticket_props["Job title"],       @raised_ticket.job
  assert_equal expected_ticket_props["Organisation"],    @raised_ticket.organisation
  assert_equal expected_ticket_props["Phone"],           @raised_ticket.phone
end

Then /^the ticket is tagged with "(.*?)"$/ do |expected_tags|
  assert_equal expected_tags, @raised_ticket.tags.join(" ")
end

Then /^the comment on the ticket is:$/ do |expected_comment_string|
  assert_equal expected_comment_string, @raised_ticket.comment
end

Then /^the time constraints on the ticket are:$/ do |ticket_properties_table|
  expected_ticket_props = ticket_properties_table.hashes.first
  @raised_ticket = @zendesk_api.ticket

  assert_equal expected_ticket_props["Need by date"], @raised_ticket.needed_by_date
  assert_equal expected_ticket_props["Not before date"], @raised_ticket.not_before_date
end