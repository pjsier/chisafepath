api_url = "http://311api.cityofchicago.org/open311/v2/requests.json"

(1..50).each { |r|
  uri = URI("#{api_url}?service_code=4ffa971e6018277d4000000b&page=#{r}")
  response = Net::HTTP.get(uri)
  begin
    rjson = JSON.parse(response)
  rescue JSON::ParserError
    rjson = nil
  end

  rjson.map{ |r|
    r_params = {
      service_request_id: r["service_request_id"],
      status: r["status"],
      lonlat: "POINT(#{r["long"]} #{r["lat"]})",
      requested_datetime: r["requested_datetime"],
      updated_datetime: r["updated_datetime"],
      address: r["address"]
    }

    r_params[:status_notes] if r["status_notes"]
    r_params[:description] if r["description"]
    r_params[:media_url] if r["media_url"]

    Issue.find_or_create_from_params(r_params)
  }
}
