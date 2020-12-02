#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject(
    beforeTest: { sh("yarn install") },
    brakeman: true,
    sassLint: false,
  )
}
