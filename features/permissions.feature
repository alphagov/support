Feature: Request permissions
  To avoid confusion from requests raised by unauthorised individuals
  As the user support manager
  I want to prevent certain roles from raising certain request types

  Scenario: permissions per role
    * The role/request matrix:
    | Role                   | Content requesters | Campaign requesters | Single points of contact | Anyone |
    | Analytics              | Y                  | Y                   | Y                        | Y      |
    | Campaign               | N                  | Y                   | Y                        | N      |
    | Content change         | Y                  | N                   | Y                        | N      |
    | Create new user        | N                  | N                   | Y                        | N      |
    | General                | Y                  | Y                   | Y                        | Y      |
    | New feature            | Y                  | N                   | Y                        | N      |
    | Remove user            | N                  | N                   | Y                        | N      |
