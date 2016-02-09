class ApiTokenJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
    pending_items = Issue.where(api_id: [nil, ''])
    api_items = []
    pending_items.map{ |i|
      unless i.api_token.nil?
        uri = URI("http://test311api.cityofchicago.org/open311/v2/tokens/#{i.api_token}.json")
        response = Net::HTTP.get(uri)
        response_json = JSON.parse(response)
        if response_json[0].key?("service_request_id")
          i.update(:api_id => response_json[0]["service_request_id"])
          api_items.push(i)
        end
      end
    }
    api_items.map{ |r|
      uri = URI("http://test311api.cityofchicago.org/open311/v2/requests/#{r.api_id}.json")
      response = Net::HTTP.get(uri)
      response_json = JSON.parse(response)
      if response_json[0].key?("media_url")
        r.remove_aws_img
        r.update(:image_url => response_json[0]["media_url"], :api_status => response_json[0]["status"])
      else
        r.update(:api_status => response_json[0]["status"])
      end
    }
  end
end
