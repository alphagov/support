Feature: FOI requests
  In order to learn about government actions that aren't openly documented yet
  As a member of the British public
  I want to lodge 'freedom of information' requests

  Background:
    * the following user has SSO access:
      | Name         | Email           | 
      | Feedback app | feedback@gov.uk |

  Scenario: successful request
    When the user submits the following FOI request through the API:
      | Name       | Email                | Details |
      | John Smith | john.smith@email.com | xyz     |
    Then the following ticket is raised in ZenDesk:
      | Subject | Requester email      | Requester name       |
      | FOI     | john.smith@email.com | John Smith           |
    And the ticket is tagged with "public_form foi_request"
    And the description on the ticket is:
      """
      [Name]
      John Smith

      [Email]
      john.smith@email.com

      [Details]
      xyz
      """
