Feature: Problem reports
  In order to fix and improve GOV.UK
  As a GDS employee
  I want to capture problem reports submitted by the general public

  Background:
    * the following user has SSO access:
      | Name         | Email           |
      | Feedback app | feedback@gov.uk |

  Scenario: successful submission
    When the user submits the following problem report through the API:
      | What you were doing | What went wrong | URL                    | User agent | JS? | Referrer             | Source            | Page owner |
      | Eating sandwich     | Fell on floor   | https://www.gov.uk/x/y | Safari     | yes | https://www.gov.uk/z | inside_government | hmrc       |
    Then the following ticket is raised in ZenDesk:
      | Subject | Requester email      |
      | /x/y    | api-user@example.com |
    And the ticket is tagged with "public_form report_a_problem govuk_referrer page_owner/hmrc"
    And the description on the ticket is:
      """
      url: https://www.gov.uk/x/y
      what_doing: Eating sandwich
      what_wrong: Fell on floor
      user_agent: Safari
      referrer: https://www.gov.uk/z
      javascript_enabled: true
      """
