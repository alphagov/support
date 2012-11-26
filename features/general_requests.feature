Feature: General requests
  In order to provide GDS with feedback
  As a government employee
  I want a means to contact GDS in the cases when my request does not covered by the other forms

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Organisation   | Phone |
      | John Smith   | john.smith@email.com | Developer | Cabinet Office | 12345 |

  Scenario: successful request
    When the user submits the following general request:
      | Details          | URL               |
      | The site is down | https://www.gov.uk |
    Then the following ticket is raised in ZenDesk:
      | Subject                   | Requester email      | Requester name | Phone | Job title | Organisation   |
      | Govt Agency General Issue | john.smith@email.com | John Smith     | 12345 | Developer | cabinet_office |
    And the ticket is tagged with "govt_agency_general"
    And the comment on the ticket is:
      """
      [Url]
      https://www.gov.uk

      [Additional]
      The site is down
      """