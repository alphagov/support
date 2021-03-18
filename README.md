# Support

This app:

- Presents anonymous feedback about pages on GOV.UK in a "feedback explorer". Anonymous feedback is collected via the [Feedback app](https://github.com/alphagov/feedback) and retrieved from the [Support API](https://github.com/alphagov/support-api).

- Exposes [internal APIs](https://github.com/alphagov/gds-api-adapters/blob/master/lib/gds_api/support.rb) to create Zendesk tickets e.g. [via the Feedback app](https://github.com/alphagov/feedback/blob/7e6893c0e80d9c98f6cea27d1bd089621054b177/app/models/contact_ticket.rb#L35). Tickets are created using the [gds_zendesk gem](https://github.com/alphagov/gds_zendesk).

- Hosts internal forms for publishers to create Zendesk tickets, as well as emergency contact info. Emergency contacts are secret and retrieved from an [environment variable](https://github.com/alphagov/govuk-puppet/blob/941373ab48ae50a9d1929caee73a52390004bf81/modules/govuk/manifests/apps/support.pp#L129) at runtime.

## Nomenclature

- **Feedback**: All the data received from contact forms is considered to be "feedback"
of some form or other and relates to pages published on GOV.UK.
- **Anonymous Contact**: Part of the feedback collected by this app is anonymous, when it's
submitted via an anonymous contact form in the [feedback app](https://github.com/alphagov/feedback).
- **Named Contact**: In contrast with the `Anonymous Contact` feedback, this is submitted
via a form that will require you to identify yourself.

## Technical documentation

This is a Ruby on Rails application.

### Running the test suite

To run the specs, execute:

    bundle exec rake

### Starting the background processing queues

Zendesk tickets are raised in the background using a redis-backed queue called [sidekiq](http://sidekiq.org/).

To start the background workers:

    rake jobs:work
