#!/bin/bash -x

export FACTER_govuk_platform=test
export RAILS_ENV=test
export DISPLAY=":99"

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
bundle exec rake stats

# DELETE STATIC SYMLINKS AND RECONNECT...
for d in images javascripts templates stylesheets; do
  rm -f public/$d
  ln -s ../../Static/public/$d public/
done

# Delete any old zendesk.yml
rm config/zendesk.yml
# Copy in the template, which will work for test mode
cp config/zendesk.yml.template config/zendesk.yml

govuk_setenv support bundle exec rake
RESULT=$?
exit $RESULT
