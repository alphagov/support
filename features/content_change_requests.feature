Feature: Content change requests
  In order to update or fix the information on gov.uk
  As a government employee
  I want a means to inform GDS about a problem with content

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful Mainstream content change request 
    When the user submits the following content change request:
      | Context                       | Details of change | URL             | Needed by date | Not before date | Reason  |
      | Mainstream (business/citizen) | Out of date XX YY | http://gov.uk/X | 31-12-2020     | 01-12-2020      | New law |

    Then the following ticket is raised in ZenDesk:
      | Subject                | Requester email      |
      | Content change request | john.smith@email.com |
    And the time constraints on the ticket are:
      | Need by date | Not before date |
      | 31-12-2020   | 01-12-2020      |
    And the ticket is tagged with "content_amend"
    And the comment on the ticket is:
      """
      [Which part of GOV.UK is this about?]
      Mainstream (business/citizen)

      [URL of content to be changed]
      http://gov.uk/X

      [Details of what should be added, amended or removed]
      Out of date XX YY

      [Time constraint reason]
      New law
      """

  Scenario: successful Inside Government content change request 
    When the user submits the following content change request:
      | Context           | Details of change |
      | Inside Government | Out of date XX YY |

    Then the following ticket is raised in ZenDesk:
      | Subject                |
      | Content change request |
    And the ticket is tagged with "content_amend inside_government"
