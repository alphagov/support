Feature: Request permissions
  To avoid confusion from requests raised by unauthorised individuals
  As the user support manager
  I want to prevent certain roles from raising certain request types

  Scenario: permissions per role (part 1)
    * The role/request matrix:
    | Role                   | Content requesters | Campaign requesters | Single points of contact |
    | Analytics              | Y                  | Y                   | Y                        |
    | Campaign               | N                  | Y                   | Y                        |
    | Content change         | Y                  | N                   | Y                        |
    | Unpublish content      | Y                  | Y                   | Y                        |
    | Create or change user  | N                  | N                   | Y                        |
    | General                | Y                  | Y                   | Y                        |
    | New feature            | Y                  | N                   | Y                        |
    | Remove user            | N                  | N                   | Y                        |
    | Technical fault report | Y                  | Y                   | Y                        |
    | ERTP problem report    | N                  | N                   | Y                        |
    | FOI                    | N                  | N                   | Y                        |
    | Problem report         | N                  | N                   | Y                        |

  Scenario: permissions per role (part 2)
    * The role/request matrix:
    | Role                   | User managers | Anyone | ERTP users | API users |
    | Analytics              | Y             | Y      | Y          | Y         |
    | Campaign               | N             | N      | N          | N         |
    | Content change         | N             | N      | N          | N         |
    | Unpublish content      | Y             | Y      | Y          | Y         |
    | Create or change user  | Y             | N      | N          | N         |
    | General                | Y             | Y      | Y          | Y         |
    | New feature            | N             | N      | N          | N         |
    | Remove user            | Y             | N      | N          | N         |
    | Technical fault report | Y             | Y      | Y          | Y         |
    | ERTP problem report    | N             | N      | Y          | N         |
    | FOI                    | N             | N      | N          | Y         |
    | Problem report         | N             | N      | N          | Y         |
