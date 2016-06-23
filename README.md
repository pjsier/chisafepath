# Chi Safe Path
Web app started at Chi Hack Night allowing people to submit 311 requests about
sidewalk accessibility hazards to the City of Chicago 311 API, and get directions
that avoid reported issues.

## Local Setup
```
rake db:setup RAILS_ENV=development
rails s
```

**Note:** To run cron tasks with the `whenever` gem, you'll need to input `whenever -w`
to write to the crontab

## Routing
Working on routing through [OpenTripPlanner](http://www.opentripplanner.org/). Dockerfile for this is from the [docker-otp-chicago](https://github.com/thcrock/docker-otp-chicago) repo.

Front end for the routing is from [a fork of bliksemlabs routing interface](https://github.com/pjsier/whitelabel)
