Feature: Technical fault reports
  In order to reduce user inconvenience and damage to government reputation
  As a government employee
  I want a means to report techincal faults to GDS

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: successful submission of technical fault report
    When the user submits the following technical fault report:
      | Location of fault                        | What is broken | User's actions | What happened | What should have happened  |
      | GOV.UK: Services and information content | Smart answer   | Clicked on x   | Broken link   | Should have linked through |
    Then the following ticket is raised in ZenDesk:
      | Subject                | Requester email      |
      | Technical fault report | john.smith@email.com |
    And the ticket is tagged with "govt_form technical_fault fault_with_gov_uk_mainstream"
    And the description on the ticket is:
      """
      [Location of fault]
      GOV.UK: Services and information content

      [What is broken]
      Smart answer

      [Actions leading to problem]
      Clicked on x

      [What happened]
      Broken link

      [What should have happened]
      Should have linked through
      """