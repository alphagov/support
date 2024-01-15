Rails.application.config.dartsass.builds = {
  "legacy/application.scss" => "legacy/application.css",
}

Rails.application.config.dartsass.build_options << " --quiet-deps"
