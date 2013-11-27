Feature: Content change requests
  In order to update or fix the information on gov.uk
  As a government employee
  I want a means to inform GDS about a problem with content

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful Services and information content change request 
    When the user submits the following content change request:
      | Context                  | Title    | Details of change | URL             | Related URLs | Needed by date | Not before date | Reason  |
      | Services and information | Update X | Out of date XX YY | http://gov.uk/X | XXXXX        | 31-12-2020     | 01-12-2020      | New law |

    Then the following ticket is raised in ZenDesk:
      | Subject                           | Requester email      |
      | Update X - Content change request | john.smith@email.com |
    And the time constraints on the ticket are:
      | Need by date | Not before date |
      | 31-12-2020   | 01-12-2020      |
    And the ticket is tagged with "govt_form content_amend"
    And the description on the ticket is:
      """
      [Which part of GOV.UK is this about?]
      Services and information

      [URL of content to be changed]
      http://gov.uk/X

      [Related URLs]
      XXXXX

      [Details of what should be added, amended or removed]
      Out of date XX YY

      [Time constraint reason]
      New law
      """

  Scenario: successful Departments and Policy content change request 
    When the user submits the following content change request:
      | Context                | Details of change |
      | Departments and policy | Out of date XX YY |

    Then the following ticket is raised in ZenDesk:
      | Subject                |
      | Content change request |
    And the ticket is tagged with "govt_form content_amend inside_government"
