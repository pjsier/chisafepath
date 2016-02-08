class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def update_from_token
    # Do something later
    pending_items = Issue.where(api_id: [nil, ''])
    api_items = pending_items.map{ |i|
      unless i.api_token.nil?
        uri = URI("http://test311api.cityofchicago.org/open311/v2/tokens/#{i.api_token}.json")
        #puts uri
        response = Net::HTTP.get(uri)
        #puts response
        response_json = JSON.parse(response)
        #puts response_json
        if response_json[0].key?("service_request_id")
          #puts response_json[0]["service_request_id"]
          i.update(:api_id => response_json[0]["service_request_id"])
          response_json[0]
        end
      end
    }
  end

  def get_new_issues
    uri = URI("http://test311api.cityofchicago.org/open311/v2/requests.json?service_code=4ffa971e6018277d4000000b")
    #puts uri
    response = Net::HTTP.get(uri)
    #puts response
    response_json = JSON.parse(response)
    response_json.map{ |r|
      unless Issue.exists?(api_id: r["service_request_id"])
        issue = Issue.find_or_create_by(api_id: pave_data["service_request_id"],
                                        api_status: pave_data["status"],
                                        service_code: pave_data["service_code"],
                                        lonlat: "POINT(#{pave_data["long"]} #{pave_data["lat"]})")
      end
    }
end
