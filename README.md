# Rake NYU

Rake NYU offers a set of common rake tasks for the NYU libraries

## New Relic
Since the NYU Libraries uses the [`rails_config`](/railsjedi/rails_config) gem, 
we need a task to explicitly load the relevant settings (e.g. license key, app name) to newrelic.yml in the absence 
of a Rails environment.

## Puma
Start, stop, and restart tasks for the [Puma webserver](http://puma.io/).
