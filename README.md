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

#### Types of requests from the Support app forms

The support app lets people who use the GOV.UK publishing tools ask for specific help from the GOV.UK team.

The types of forms and their purpose are listed below:
- "Content advice and help": Asking for help or advice on any content problems. Request short URLs, topical event pages, groups or manuals
- "Content changes and new content requests": Request changes to GOV.UK content managed by GDS content designers
- "Unpublish content": Request to unpublish content
- "Changes to publishing applications or technical advice": Request for changes or new features for any publishing applications or ask for technical advice. Also used for transitioning new sites to GOV.UK.
- "Report a technical fault to GDS": report something that is not working with any publishing application, eg Whitehall, finders or specialist publisher. Also used for urgent technical changes.
- "Accounts, permissions and training": Request a new account, change an account or unlock an account
- "Remove user": Request to remove user access
- "Request a new campaign": Request GDS supoort for a new campaign
- "Support for live campaign": Request GDS support for a live campaign
- "Suggest a new topic": Suggest a new topic for the GOV.UK taxonomy
- "Suggest a change to a topic": Suggest a change to a topic or the removal of a topic in the GOV.UK taxonomy
- "Analytics access, reports and help": Request access to Google Analytics or help with analytics and reports
- "General": Report a problem, request GDS support, or make a suggestion
- "Feedback explorer": GOV.UK Anonymous Feedback
- "Emergency contact details": Contact GOV.UK in an emergency

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

- [alphagov/support-api](https://github.com/alphagov/feedback) - provides an API for storing
and fetching anonymous feedback about pages on GOV.UK.

### Running the application

To start the app using `bowler`:

    bowl support

To start the app directly:

    ./startup.sh

This will start the app on port `3031`.

Default url for development: `https://support.dev.gov.uk/`, for production:
`https://support.publishing.service.gov.uk`

### Running the test suite

To run the specs, execute:

    bundle exec rake

### Starting the background processing queues

Zendesk tickets are raised in the background using a redis-backed queue called [sidekiq](http://sidekiq.org/).

To start the background workers:

    rake jobs:work
