Feature: Feedback explorer
  In order to improve content and services on GOV.UK
  As a government user
  I want to view anonymous feedback left by members of the public

  Background:
    * the following user has SSO access:
      | Name         | Email                |
      | John Smith   | john.smith@email.com |

  Scenario: explore using URL
    Given the following problem reports have been left by members of the public:
      | URL                          | Creation date | What user was doing      | What went wrong        | User came from             |
      | https://www.gov.uk/tax-disc  | 2013-01-01    | logging in               | error                  | https://www.gov.uk         |
      | https://www.gov.uk/vat-rates | 2013-02-01    | looking at rates         | standard rate is wrong | https://www.gov.uk/pay-vat |
      | https://www.gov.uk/vat-rates | 2013-03-01    | looking at 3rd paragraph | typo in 2rd word       | https://www.gov.uk         |
    When the user explores the feedback with the following filters:
      | URL                          |
      | https://www.gov.uk/vat-rates |
    Then the following result is shown:
      | creation date | feedback                                                        | full path  | user came from             |
      | 01.03.2013    | action: looking at 3rd paragraph\n    problem: typo in 2rd word | /vat-rates | https://www.gov.uk         |
      | 01.02.2013    | action: looking at rates\n    problem: standard rate is wrong   | /vat-rates | https://www.gov.uk/pay-vat |

  Scenario: explore doesn't return reports with email or national insurance numbers
    Given the following problem reports have been left by members of the public:
      | URL                          | Creation date | What user was doing      | What went wrong        | User came from             |
      | https://www.gov.uk/vat-rates | 2013-01-01    | logging in               | email me at ab@c.com   | https://www.gov.uk         |
      | https://www.gov.uk/vat-rates | 2013-02-01    | looking at rates         | my NI is PP999999P     | https://www.gov.uk/pay-vat |
      | https://www.gov.uk/vat-rates | 2013-03-01    | looking at 3rd paragraph | typo in 2rd word       | https://www.gov.uk         |
    When the user explores the feedback with the following filters:
      | URL                          |
      | https://www.gov.uk/vat-rates |
    Then the following result is shown:
      | creation date | feedback                                                        | full path  | user came from             |
      | 01.03.2013    | action: looking at 3rd paragraph\n    problem: typo in 2rd word | /vat-rates | https://www.gov.uk         |
