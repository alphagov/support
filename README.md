# Support

Forms that create tickets for requests coming from government agencies or from GOV.UK contact forms.

## Nomenclature

- **Feedback**: All the data received from contact forms is considered to be "feedback"
of some form or other and relates to pages published on GOV.UK.
- **Anonymous Contact**: Part of the feedback collected by this app is anonymous, when it's
submitted via an anonymous contact form in the [feedback app](https://github.com/alphagov/feedback).
- **Named Contact**: In contrast with the `Anonymous Contact` feedback, this is submitted
via a form that will require you to identify yourself. This data is sent directly
to the `support` app.

## Technical documentation

This is a Ruby on Rails application which collects feedback and creates tickets based on it.
It collects data from two sources:
- its own forms which can be accessed by [signon](https://github.com/alphagov/signon) users
- contact forms from the [feedback app](https://github.com/alphagov/feedback)

The data collected from either the `feedback` app or its own forms is then used to create
and submit Zendesk tickets.

Even though it is not public facing, the `support` app does receive data from the [feedback app](https://github.com/alphagov/feedback),
which collects data via contact forms rendered on GOV.UK.

#### Feedback explorer

At the bottom of every page on GOV.UK we ask: “Is there anything wrong with this page?”.
Users can leave comments on what they were doing and what went wrong. Feedback is anonymous
and is collected via the `feedback` app.

The Feedback explorer in the `support` app allows users to browse the feedback submitted from GOV.UK pages,
and to export CSVs of the same for further analysis.

#### Zendesk

Currently we use Zendesk to register our support tickets, via the `gds_zendesk` gem which is
a wrapper around the Zendesk API.

### Dependencies

- [alphagov/support-api](https://github.com/alphagov/support-api) - provides an API for storing
and fetching anonymous feedback about pages on GOV.UK.

### Running the test suite

To run the specs, execute:

    bundle exec rake

### Starting the background processing queues

Zendesk tickets are raised in the background using a redis-backed queue called [sidekiq](http://sidekiq.org/).

To start the background workers:

    rake jobs:work
