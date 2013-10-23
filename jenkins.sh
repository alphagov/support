#!/bin/bash -x

# This removes rbenv shims from the PATH where there is no
# .ruby-version file. This is because certain gems call their
# respective tasks with ruby -S which causes the following error to
# appear: ruby: no Ruby script found in input (LoadError).
if [ ! -f .ruby-version ]; then
  export PATH=$(printf $PATH | awk 'BEGIN { RS=":"; ORS=":" } !/rbenv/' | sed 's/:$//')
fi

export FACTER_govuk_platform=test
export RAILS_ENV=test
export GOVUK_APP_DOMAIN=dev.gov.uk
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

bundle exec rake db:drop db:create db:schema:load
bundle exec rake
RESULT=$?
exit $RESULT
