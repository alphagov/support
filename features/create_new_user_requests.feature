Feature: Create new user requests
  In order to allow new departments to submit requests to GDS
  As well as to allow for existing departments to shift responsibilities around
  As a government employee
  I want a means to request GDS tool access for other users

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful create user request for publisher
    When the user submits the following create user request:
      | Tool/Role                 | User's name | User's email | User's job title | User's phone | Additional comments |
      | Departmental Contact Form | Bob Fields  | bob@gov.uk   | Editor           | 12345        | XXXX                |
    Then the following ticket is raised in ZenDesk:
      | Subject         | Requester email      |
      | Create new user | john.smith@email.com |
    And the ticket is tagged with "new_user"
    And the comment on the ticket is:
      """
      [Tool/Role]
      Departmental Contact Form

      [Requested user's name]
      Bob Fields

      [Requested user's email]
      bob@gov.uk

      [Requested user's job title]
      Editor

      [Requested user's phone number]
      12345

      [Additional comments]
      XXXX
      """