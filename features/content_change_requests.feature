Feature: Content change requests
  In order to update or fix the information on gov.uk
  As a government employee
  I want a means to inform GDS about a problem with content

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Organisation   | Phone |
      | John Smith   | john.smith@email.com | Developer | Cabinet Office | 12345 |

  Scenario: successful request
    When the user submits the following content change request:
      | Details of change | URL 1            | URL 2           | Needed by date | Not before date | Reason  |
      | Out of date XX YY | http://gov.com/X | http://gov.uk/Y | 31-12-2012     | 01-12-2012      | New law |

    Then the following ticket is raised in ZenDesk:
      | Subject                | Requester email      | Requester name | Phone | Job title | Organisation   |
      | Content change request | john.smith@email.com | John Smith     | 12345 | Developer | cabinet_office |
    And the time constraints on the ticket are:
      | Need by date | Not before date |
      | 31-12-2012   | 01-12-2012      |
    And the ticket is tagged with "content_amend"
    And the comment on the ticket is:
      """
      [URl(s) of content to be changed]
      http://gov.com/X
      http://gov.uk/Y

      [Details of what should be added, amended or removed]
      Out of date XX YY

      [Time constraint reason]
      New law
      """