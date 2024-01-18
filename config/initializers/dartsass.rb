Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css",
  "legacy/application.scss" => "legacy/application.css",
}

Rails.application.config.dartsass.build_options << " --quiet-deps"
