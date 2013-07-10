Feature: Create or change user requests
  In order to allow departments to shift responsibilities around
  As a departmental user manager
  I want to request GDS tool access or new permissions for other users

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: user creation request
    When the user submits the following request to create or change users:
      | Action           | Tool/Role                 | User's name | User's email | User's job title | User's phone | Additional comments |
      | New user account | Departmental Contact Form | Bob Fields  | bob@gov.uk   | Editor           | 12345        | XXXX                |
    Then the following ticket is raised in ZenDesk:
      | Subject          | Requester email      |
      | New user account | john.smith@email.com |
    And the ticket is tagged with "govt_form create_new_user"
    And the description on the ticket is:
      """
      [Action]
      New user account

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