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
      | Action           | User needs                                                                 | User's name | User's email | User's job title | User's phone | Additional comments |
      | New user account | Inside Government writer permissions, Inside Government editor permissions | Bob Fields  | bob@gov.uk   | Editor           | 12345        | XXXX                |
    Then the following ticket is raised in ZenDesk:
      | Subject          | Requester email      |
      | New user account | john.smith@email.com |
    And the ticket is tagged with "govt_form create_new_user inside_government"
    And the description on the ticket is:
      """
      [Action]
      New user account

      [User needs]
      Inside Government editor permissions, Inside Government writer permissions

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

  Scenario: changing user permissions
    When the user submits the following request to create or change users:
      | Action                                | User needs     | User's name | User's email | Additional comments |
      | Change an existing user's permissions | Other/Not sure | Bob Fields  | bob@gov.uk   | XXXX                |
    Then the following ticket is raised in ZenDesk:
      | Subject                               | Requester email      |
      | Change an existing user's permissions | john.smith@email.com |
    And the ticket is tagged with "govt_form change_user"
    And the description on the ticket is:
      """
      [Action]
      Change an existing user's permissions

      [User needs]
      Other/Not sure

      [Requested user's name]
      Bob Fields

      [Requested user's email]
      bob@gov.uk

      [Additional comments]
      XXXX
      """