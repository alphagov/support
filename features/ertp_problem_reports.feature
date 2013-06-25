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
      | CC ticket # | Local authority | Multiple LAs | Problem description | Investigation | Incident stage | Additional |
      | 12345       | Southwark       | true         | broken              | logs          | stage 1        | nothing    |
    Then the following ticket is raised in ZenDesk:
      | Subject                       |
      | stage 1 - ERTP problem report |
    And the ticket is tagged with "govt_form ertp_problem_report non_gov_uk"
    And the description on the ticket is:
      """
      [Control Center ticket number]
      12345

      [Local authority]
      Southwark

      [Incident stage]
      stage 1

      [Multiple local authorities impacted?]
      yes

      [Problem description]
      broken

      [Details of the investigation]
      logs

      [Additional]
      nothing
      """
