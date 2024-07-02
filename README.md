TEST
# Support

This app:

- Presents anonymous feedback about pages on GOV.UK in a "feedback explorer". Anonymous feedback is collected via the [Feedback app](https://github.com/alphagov/feedback) and retrieved from the [Support API](https://github.com/alphagov/support-api).

- Hosts internal forms for publishers to create Zendesk tickets.

- Hosts emergency contact information. This is read from an [environment variable](https://github.com/alphagov/govuk-helm-charts/blob/fb1920b/charts/app-config/values-production.yaml#L2420) which ultimately comes from a secret in AWS Secrets Manager.

## Nomenclature

- **Feedback**: All the data received from contact forms is considered to be "feedback"
of some form or other and relates to pages published on GOV.UK.
- **Anonymous Contact**: Part of the feedback collected by this app is anonymous, when it's
submitted via an anonymous contact form in the [feedback app](https://github.com/alphagov/feedback).

## Technical documentation

This is a Ruby on Rails app, and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the application and its tests with all the necessary dependencies. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

### Running the test suite

```
bundle exec rake
```

### Running the worker

Zendesk tickets are raised in the background using a [Sidekiq](http://sidekiq.org/) worker.

To start the background worker:

```
bundle exec sidekiq
```

## Further documentation

- [An overview of how the Feedback, Support and Support API applications fit together](https://docs.google.com/presentation/d/1KNJQsH7Stu1hAe8DL-Zs585Q_yXSleGYiH0G6Sw6rOw/edit#slide=id.g59de842929_0_5) (for internal use only)
- [Zendesk routing](./docs/how-tickets-routed-to-zendesk.md)

## Licence

[MIT License](LICENCE)
