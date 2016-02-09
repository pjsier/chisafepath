class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    uri = URI("http://test311api.cityofchicago.org/open311/v2/requests.json?service_code=4ffa971e6018277d4000000b")
    #puts uri
    response = Net::HTTP.get(uri)
    #puts response
    response_json = JSON.parse(response)
    response_json.map{ |r|
      dummy_img = nil
      unless r["media_url"].blank?
        dummy_img = r["media_url"]
      end

      unless Issue.exists?(api_id: r["service_request_id"])
        issue = Issue.find_or_create_by(api_id: r["service_request_id"],
                                        api_status: r["status"],
                                        service_code: r["service_code"],
                                        lonlat: "POINT(#{r["long"]} #{r["lat"]})",
                                        image_url: dummy_img)
      end
    }
  end

end
