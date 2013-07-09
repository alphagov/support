Feature: Unpublish content requests
  In order to reduce user confusion and damage to government reputation
  As a government employee
  I want to ask the Inside Government team to unpublish content

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: request to unpublish in case of publishing error
    When the user submits the following request to unpublish content:
      | URL                  | Reason             | Further explanation |
      | https://www.gov.uk/X | Published in error | Typo in slug name   |
    Then the following ticket is raised in ZenDesk:
      | Subject                   |
      | Published in error - Unpublish content request |
    And the ticket is tagged with "govt_form unpublish_content inside_government published_in_error"
    And the description on the ticket is:
      """
      [URL of content to be unpublished]
      https://www.gov.uk/X

      [Reason]
      Published in error

      [Further explanation]
      Typo in slug name
      """
