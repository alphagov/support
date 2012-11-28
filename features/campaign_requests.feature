Feature: Campaign requests
  In order to run a successful campaign
  As a government employee
  I want a means to request GDS support for a campaign

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Organisation   | Phone |
      | John Smith   | john.smith@email.com | Developer | Cabinet Office | 12345 |

  Scenario: successful campaign request
    When the user submits the following campaign request:
      | Campaign title     | ERG ref number | Start date | Description | Affiliated group | Info URL           | Additional comments |
      | Workplace pensions | 123456         | 01-01-2020 | Pensions    | AXA              | https://www.gov.uk | Some comment        |
    Then the following ticket is raised in ZenDesk:
      | Subject  | Requester email      | Requester name | Phone | Job title | Organisation   |
      | Campaign | john.smith@email.com | John Smith     | 12345 | Developer | cabinet_office |
    And the ticket is tagged with "campaign"
    And the comment on the ticket is:
      """
      [Campaign title]
      Workplace pensions

      [ERG reference number]
      123456

      [Start date]
      01-01-2020

      [Description]
      Pensions

      [Affiliated group or company]
      AXA

      [URL with more information]
      https://www.gov.uk

      [Additional comments]
      Some comment
      """