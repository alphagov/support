Feature: Request permissions
  To avoid confusion from requests raised by unauthorised individuals
  As the user support manager
  I want to prevent certain roles from raising certain request types

  Scenario: permissions per role
    * The role/request matrix:
    | Role                   | Content requesters | Campaign requesters | Single points of contact | User managers | Anyone | ERTP users |
    | Analytics              | Y                  | Y                   | Y                        | Y             | Y      | Y          |
    | Campaign               | N                  | Y                   | Y                        | N             | N      | N          |
    | Content change         | Y                  | N                   | Y                        | N             | N      | N          |
    | Unpublish content      | Y                  | N                   | Y                        | N             | N      | N          |
    | Create or change user  | N                  | N                   | Y                        | Y             | N      | N          |
    | General                | Y                  | Y                   | Y                        | Y             | Y      | Y          |
    | New feature            | Y                  | N                   | Y                        | N             | N      | N          |
    | Remove user            | N                  | N                   | Y                        | Y             | N      | N          |
    | Technical fault report | Y                  | Y                   | Y                        | Y             | Y      | Y          |
    | ERTP problem report    | N                  | N                   | Y                        | N             | N      | Y          |
