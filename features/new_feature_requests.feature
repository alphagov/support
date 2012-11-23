Feature: New feature requests
  In order to fulfill user needs not currently met by gov.uk
  As a government employee
  I want a means to contact GDS and request new features

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Organisation   | Phone |
      | John Smith   | john.smith@email.com | Developer | Cabinet Office | 12345 |

  Scenario: successful request
    When the user submits the following new feature request:
      | Context           | User need          | URL of example         | Needed by date | Not before date | Reason            |
      | Inside Government | Information on XYZ | http://www.example.com | 31-12-2012     | 01-12-2012      | Legal requirement |

    Then the following ticket is raised in ZenDesk:
      | Subject             | Requester email      | Requester name | Phone | Job title | Organisation   |
      | New Feature Request | john.smith@email.com | John Smith     | 12345 | Developer | cabinet_office |
    And the time constraints on the ticket are:
      | Need by date | Not before date |
      | 31-12-2012   | 01-12-2012      |
    And the ticket is tagged with "new_feature_request inside_government"
    And the comment on the ticket is:
      """
      [Which part of GOV.UK is this about?]
      inside_government

      [User need]
      Information on XYZ

      [Url of example]
      http://www.example.com

      [Time constraint reason]
      Legal requirement
      """