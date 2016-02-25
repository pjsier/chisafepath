class ApiStatusJob < ActiveJob::Base
  queue_as :default

  def perform
    open_issues = Issue.where("api_status = ? AND created_at >= ?",
                              "open",
                              3.months.ago)
    open_issues.map { |i| puts i.api_id }
  end
end
