Feature: Request permissions
  To avoid confusion from requests raised by unauthorised individuals
  As the user support manager
  I want to prevent certain roles from raising certain request types

  Scenario: permissions per role
    * The role/request matrix:
    | Role                     | General | Content change | New feature | Campaign | Create new user | Remove user | Analytics |
    | Content requesters       | Y       | Y              | Y           | N        | N               | N           | Y         |
    | Campaign requesters      | Y       | N              | N           | Y        | N               | N           | Y         |
    | Single points of contact | Y       | Y              | Y           | Y        | Y               | Y           | Y         |
    | Anyone                   | Y       | N              | N           | N        | N               | N           | Y         |