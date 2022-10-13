ARG base_image=ghcr.io/alphagov/govuk-ruby-base:2.7.6
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:2.7.6

FROM $builder_image AS builder

WORKDIR /app

COPY Gemfile* .ruby-version /app/

RUN bundle install

COPY . /app

RUN bundle exec rails assets:precompile && rm -fr /app/log


FROM $base_image

ENV GOVUK_APP_NAME=support

WORKDIR /app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app/

USER app

CMD bundle exec puma