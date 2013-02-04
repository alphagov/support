Feature: Analytics requests
  In order to measure the impact of my content (e.g. a campaign)
  As a government employee
  I want a means to request analytics data from GDS

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful analytics request
    When the user submits the following analytics request:
      | Context                       | From          | To       | Pages/sections/URLs | What's it for              | More detailed analysis | Frequency | Format |
      | Mainstream (business/citizen) | Start Q4 2012 | End 2012 | https://gov.uk/X    | To measure campaign success | I also need KPI Y      | One-off   | PDF    |
    Then the following ticket is raised in ZenDesk:
      | Subject               | Requester email      |
      | Request for analytics | john.smith@email.com |
    And the ticket is tagged with "govt_form analytics"
    And the comment on the ticket is:
      """
      [Which part of GOV.UK is this about?]
      Mainstream (business/citizen)

      [Reporting period]
      From Start Q4 2012 to End 2012

      [Requested pages/sections]
      https://gov.uk/X

      [Justification for needing report]
      To measure campaign success

      [More detailed analysis needed?]
      I also need KPI Y

      [Reporting frequency]
      One-off

      [Report format]
      PDF
      """