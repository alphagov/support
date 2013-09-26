Feature: Named contacts
  In order to resolve issue I am having with something to do with GOV.UK
  As a member of the public
  I can ask GOV.UK support to help me

  Background:
    * the following user has SSO access:
      | Name         | Email           |
      | Feedback app | feedback@gov.uk |

  Scenario: successful contact (to do with entire site)
    When the user submits the following named contact through the API:
      | Name       | Email                | Details | User agent  | JS? | Referrer             |
      | John Smith | john.smith@email.com | xyz     | Mozilla/5.0 | yes | https://www.gov.uk/x |
    Then the following ticket is raised in ZenDesk:
      | Subject       | Requester email      | Requester name |
      | Named contact | john.smith@email.com | John Smith     |
    And the ticket is tagged with "public_form named_contact"
    And the description on the ticket is:
      """
      [Requester]
      John Smith <john.smith@email.com>

      [Details]
      xyz

      [Referrer]
      https://www.gov.uk/x

      [User agent]
      Mozilla/5.0

      [JavaScript Enabled]
      true
      """

  Scenario: successful contact (to do with a specific page)
    When the user submits the following named contact through the API:
      | Name       | Email                | Details | Link                 |
      | John Smith | john.smith@email.com | xyz     | https://www.gov.uk/y |
    Then the following ticket is raised in ZenDesk:
      | Subject                |
      | Named contact about /y |
    And the description on the ticket is:
      """
      [Requester]
      John Smith <john.smith@email.com>

      [Details]
      xyz

      [Link]
      https://www.gov.uk/y

      [Referrer]
      Unknown

      [User agent]
      Unknown

      [JavaScript Enabled]
      false
      """
