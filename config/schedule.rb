set :output, "/log/cron_log.log"

every 30.minutes do
  runner "ApiUpdateJob.perform_now"
end

every 1.day, :at => '12:00 am' do
  runner "ImageCleanupJob.perform_now"
end
