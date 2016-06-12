# Chi Safe Path
Web app started at Chi Hack Night allowing people to submit 311 requests about
sidewalk accessibility hazards to the City of Chicago 311 API by entering in
their location or submitting a geotagged picture.

## Local Docker deploy (Mac OSX)
```
docker-machine create -d virtualbox chisafepath
docker-compose build
docker-compose run chisafepath rake db:setup RAILS_ENV=development
docker-compose up
```

## Local Setup without Docker
```
rake db:setup RAILS_ENV=development
rails s
```

## Routing
Working on routing through [OpenTripPlanner](http://www.opentripplanner.org/). Dockerfile for this is from the [docker-otp-chicago](https://github.com/thcrock/docker-otp-chicago) repo.
