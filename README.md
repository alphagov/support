# Support

Forms that create Zendesk tickets for requests coming from government agencies. 
The app is written in Rails and uses the zendesk_api gem to connect to Zendesk.

### To start the app:

Mocking out SSO:

    rake users:create_dummy
    bowl support

Against a real SSO instance:

    GDS_SSO_STRATEGY=real bowl signon support

### Tests

To run unit tests, execute

    govuk_setenv support bundle exec rake test

