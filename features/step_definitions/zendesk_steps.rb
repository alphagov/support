Given /^there are no users with email "(.*?)" in Zendesk$/ do |email|
  self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  zendesk_has_no_user_with_email(email)
end

Then /^the following ticket is raised in ZenDesk:$/ do |ticket_properties_table|
  expected_ticket_props = ticket_properties_table.hashes.first

  assert_created_ticket_has(subject: expected_ticket_props["Subject"]) if expected_ticket_props["Subject"]

  if expected_ticket_props["Requester email"]
    assert_created_ticket_has_requester(email: expected_ticket_props["Requester email"])
  end

  if expected_ticket_props["Requester name"]
    assert_created_ticket_has_requester(name: expected_ticket_props["Requester name"])
  end
end

Then /^the ticket is tagged with "(.*?)"$/ do |expected_tags|
  assert_created_ticket_has(tags: expected_tags.split(" "))
end

Then /^the description on the ticket is:$/ do |expected_comment_string|
  assert_created_ticket_has(comment: { body: expected_comment_string })
end

Then /^the time constraints on the ticket are:$/ do |ticket_properties_table|
  expected_ticket_props = ticket_properties_table.hashes.first

  assert_created_ticket_has(fields: [
    { id: GDSZendesk::FIELD_MAPPINGS[:needed_by_date], value: expected_ticket_props["Need by date"] },
    { id: GDSZendesk::FIELD_MAPPINGS[:not_before_date], value: expected_ticket_props["Not before date"] }
  ])
end

Then /^the ticket priority is "(.*?)"$/ do |expected_priority|
  assert_created_ticket_has(priority: expected_priority)
end
