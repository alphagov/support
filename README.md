# Support

Forms that create Zendesk tickets for requests coming from government agencies. 
The app is written in Rails and uses the zendesk_api gem to connect to Zendesk.

### To start the app:

Mocking out SSO:

    rake users:create_dummy
    bowl support

Against a real SSO instance:

    GDS_SSO_STRATEGY=real bowl signon support

### Starting the background processing queues

Zendesk tickets are raised in the background using a redis-backed queue called [sidekiq](http://sidekiq.org/).

To start the background workers:

    rake jobs:work

### Tests/specs

To run the specs, execute:

    bundle exec rake

