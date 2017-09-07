#!/usr/bin/env groovy

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  govuk.buildProject(
    sassLint: false,
    overrideTestTask: {
      stage("Run custom tests") {
        govuk.runRakeTask("ci:setup:rspec default")
      }
    }
  )
}
