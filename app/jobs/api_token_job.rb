class ApiTokenJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
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
end
