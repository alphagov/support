Feature: Create new user requests
  In order to allow new departments to submit requests to GDS
  As well as to allow for existing departments to shift responsibilities around
  As a government employee
  I want a means to request GDS tool access for other users

  Background:
    * the following user has SSO access:
      | Name         | Email                | Job title | Phone |
      | John Smith   | john.smith@email.com | Developer | 12345 |

  Scenario: successful create user request for publisher
    When the user submits the following create user request:
      | Tool/Role                 | User's name | User's email | Additional comments |
      | Departmental Contact Form | Bob Fields  | bob@gov.uk   | XXXX                |
    Then the following ticket is raised in ZenDesk:
      | Subject         | Requester email      | Requester name | Phone | Job title |
      | Create new user | john.smith@email.com | John Smith     | 12345 | Developer |
    And the ticket is tagged with "new_user"
    And the comment on the ticket is:
      """
      [Tool/Role]
      Departmental Contact Form

      [User name]
      Bob Fields

      [User email]
      bob@gov.uk

      [Additional comments]
      XXXX
      """