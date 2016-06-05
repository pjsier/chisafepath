# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/log/cron_log.log"

every 10.minutes do
  runner "ApiTokenJob.perform_now"
end

every 15.minutes do
  runner "ApiStatusJob.perform_now"
end

every 12.hours do
  runner "ApiUpdateJob.perform_now"
end
