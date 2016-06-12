set :output, "/log/cron_log.log"

every 30.minutes do
  runner "ApiUpdateJob.perform_now"
end
