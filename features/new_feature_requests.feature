Feature: New feature requests
  In order to fulfill user needs not currently met by gov.uk
  As a government employee
  I want a means to contact GDS and request new features

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful request
    When the user submits the following new feature request:
      | Context           | User need          | URL of example         | Needed by date | Not before date | Reason            |
      | Inside Government | Information on XYZ | http://www.example.com | 31-12-2020     | 01-12-2020      | Legal requirement |

    Then the following ticket is raised in ZenDesk:
      | Subject             | Requester email      |
      | New Feature Request | john.smith@email.com |
    And the time constraints on the ticket are:
      | Need by date | Not before date |
      | 31-12-2020   | 01-12-2020      |
    And the ticket is tagged with "govt_form new_feature_request inside_government"
    And the description on the ticket is:
      """
      [Which part of GOV.UK is this about?]
      Inside Government

      [User need]
      Information on XYZ

      [Url of example]
      http://www.example.com

      [Time constraint reason]
      Legal requirement
      """