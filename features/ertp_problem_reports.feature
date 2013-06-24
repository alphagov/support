Feature: ERTP problem reports
  In order to reduce user inconvenience and damage to government reputation
  As a memeber of the ERTP project
  I want a means to report ERTP techincal faults to GDS

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful request
    When the user submits the following ERTP problem report:
      | Details          | URL                |
      | The site is down | https://www.gov.uk |
    Then the following ticket is raised in ZenDesk:
      | Subject                   |
      | New ERTP problem report   |
    And the ticket is tagged with "govt_form ertp_problem_report non_gov_uk"
    And the description on the ticket is:
      """
      [Url]
      https://www.gov.uk

      [Additional]
      The site is down
      """
