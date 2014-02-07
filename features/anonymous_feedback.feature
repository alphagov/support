Feature: Anonymous feedback
  In order to fix and improve GOV.UK
  As a GDS employee
  I want to capture bugs, gripes and improvement suggestions submitted by the general public

  Background:
    * the following user has SSO access:
      | Name         | Email           |
      | Feedback app | feedback@gov.uk |

  Scenario: successful problem report submission
    When the user submits the following problem report through the API:
      | What you were doing | What went wrong | URL                    | User agent | JS? | Referrer             | Source            | Page owner |
      | Eating sandwich     | Fell on floor   | https://www.gov.uk/x/y | Safari     | yes | https://www.gov.uk/z | inside_government | hmrc       |
    Then the following ticket is raised in ZenDesk:
      | Subject | Requester email      |
      | /x/y    | api-user@example.com |
    And the ticket is tagged with "anonymous_feedback public_form report_a_problem inside_government govuk_referrer page_owner/hmrc"
    And the description on the ticket is:
      """
      url: https://www.gov.uk/x/y
      what_doing: Eating sandwich
      what_wrong: Fell on floor
      user_agent: Safari
      referrer: https://www.gov.uk/z
      javascript_enabled: true
      """

  Scenario: successful long-form anonymous contact (to do with a specific page)
    When the user submits the following long-form anonymous contact through the API:
      | Details | Link                 |
      | xyz     | https://www.gov.uk/y |
    Then the following ticket is raised in ZenDesk:
      | Subject                    |
      | Anonymous contact about /y |
    And the ticket is tagged with "anonymous_feedback public_form long_form_contact"
    And the description on the ticket is:
      """
      [Details]
      xyz

      [Url]
      https://www.gov.uk/y

      [Referrer]
      Unknown

      [User agent]
      Unknown

      [JavaScript Enabled]
      false
      """

  Scenario: successful service feedback submission with comment
    Given the date is 2013-02-28
    When the user submits feedback about a GOV.UK service through the API:
      | Slug                     | URL                                         | Satisfaction rating  | Improvement comments    | User agent | JS? |
      | done/find-court-tribunal | https://www.gov.uk/done/find-court-tribunal | 3                    | Make service less 'meh' | Safari     | yes |
    And the user explores the feedback with the following filters:
      | URL                                         |
      | https://www.gov.uk/done/find-court-tribunal |
    Then the following result is shown:
      | creation date | feedback                                        | full path                 | user came from |
      | 28.02.2013    | rating: 3\n    comment: Make service less 'meh' | /done/find-court-tribunal | –              |

  Scenario: successful service feedback submission without comment
    Given the date is 2013-02-28
    When the user submits feedback about a GOV.UK service through the API:
      | Slug                     | URL                                         | Satisfaction rating  | Improvement comments    | User agent | JS? |
      | done/find-court-tribunal | https://www.gov.uk/done/find-court-tribunal | 3                    |                         | Safari     | yes |
    And the user explores the feedback with the following filters:
      | URL                                         |
      | https://www.gov.uk/done/find-court-tribunal |
    Then the following result is shown:
      | creation date | feedback  | full path                 | user came from |
      | 28.02.2013    | rating: 3 | /done/find-court-tribunal | –              |
