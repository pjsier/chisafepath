class ApiStatusJob < ActiveJob::Base
  queue_as :default

  def perform
    open_issues = Issue.where("api_status = ? AND created_at >= ?",
                              "open",
                              3.months.ago)
    if Rails.env.production?
      api_url = "http://311api.cityofchicago.org/open311/v2/requests.json"
    else
      api_url = "http://test311api.cityofchicago.org/open311/v2/requests.json"
    end

    open_issues.map { |i|

      uri = URI("#{api_url}/#{r.api_id}.json")
      response = Net::HTTP.get(uri)
      rjson = JSON.parse(response)[0]

      if rjson["status"] == "closed"
        i.update(api_status: "closed")
      end
    }
  end
end
