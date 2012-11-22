Feature: Create new user requests
  In order to allow new departments to submit requests to GDS
  As well as to allow for existing departments to shift responsibilities around
  As a government employee
  I want a means to request GDS tool access for other users

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Organisation   | Phone |
      | John Smith   | john.smith@email.com | Developer | Cabinet Office | 12345 |

  Scenario: successful request
    When the user submits the following create user request:
      | User's name | User's email | Additional comments |
      | Bob Fields  | bob@gov.uk   | Editor              |
    Then the following ticket is raised in ZenDesk:
      | Subject         | Requester email      | Requester name | Phone | Job title | Organisation   |
      | Create new user | john.smith@email.com | John Smith     | 12345 | Developer | cabinet_office |
    And the ticket is tagged with "new_user"
    And the comment on the ticket is:
      """
      [User name]
      Bob Fields

      [User email]
      bob@gov.uk

      [Additional comments]
      Editor
      """