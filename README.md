# Support

Forms that create Zendesk tickets for requests coming from government agencies. 
The app is written in Rails and uses the zendesk_api gem to connect to Zendesk.

### To start the app:

    GDS_SSO_STRATEGY=real bowl signon support

### Tests

To run unit tests, execute

    govuk_setenv support bundle exec rake test

