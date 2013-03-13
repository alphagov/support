Feature: Remove user requests
  In order to revoke access from users who are no longer authorised to use GDS tools
  As a government employee
  I want a means to request removal of GDS tool access for other users

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful remove user request for publisher
    When the user submits the following remove user request:
      | Tool/Role                 | User's name  | User's email | Not before date | Reason for removal |
      | Departmental Contact Form | Bob Wasfired | bob@gov.uk   | 31-12-2020      | XXXX               |
    Then the following ticket is raised in ZenDesk:
      | Subject     | Requester email      | Phone | Job title |
      | Remove user | john.smith@email.com | 12345 | Developer |
    And the ticket is tagged with "govt_form remove_user"
    And the time constraints on the ticket are:
      | Not before date |
      | 31-12-2020      |
    And the comment on the ticket is:
      """
      [Tool/Role]
      Departmental Contact Form

      [User name]
      Bob Wasfired

      [User email]
      bob@gov.uk

      [Reason for removal]
      XXXX
      """