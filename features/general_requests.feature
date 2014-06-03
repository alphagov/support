Feature: General requests
  In order to provide GDS with feedback
  As a government employee
  I want a means to contact GDS in the cases when my request does not covered by the other forms

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful request
    When the user submits the following general request:
      | Title    | Details          | URL               |
      | Downtime | The site is down | https://www.gov.uk |
    Then the following ticket is raised in ZenDesk:
      | Subject                              | Requester email      | Requester name       |
      | Downtime - Govt Agency General Issue | john.smith@email.com | John Smith           |
    And the ticket is tagged with "govt_form govt_agency_general"
    And the description on the ticket is:
      """
      [Url]
      https://www.gov.uk

      [Details]
      The site is down
      """
