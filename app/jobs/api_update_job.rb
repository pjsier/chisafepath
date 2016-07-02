class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform
    api_url = "http://311api.cityofchicago.org/open311/v2/requests.json"
    query_time = Time.now - 30.minutes
    query_time = query_time.strftime("%Y-%m-%dT%H:%M:%S-05:00")
    uri = URI("#{api_url}?service_code=4ffa971e6018277d4000000b&updated_after#{query_time}")

    response = Net::HTTP.get(uri)
    begin
      rjson = JSON.parse(response)
      rjson.map{ |r|
        r_params = {
          service_request_id: r["service_request_id"],
          status: r["status"],
          lon: r["long"],
          lat: r["lat"],
          requested_datetime: r["requested_datetime"],
          updated_datetime: r["updated_datetime"],
          address: r["address"]
        }

        r_params[:status_notes] = r["status_notes"] unless r["status_notes"].nil?
        r_params[:description] = r["description"] unless r["description"].nil?
        r_params[:media_url] = r["media_url"] unless r["media_url"].nil?

        Issue.find_or_create_from_params(r_params)
      }
    rescue Exception
      logger.error "Error for query: #{uri}"
    end
  end

end
