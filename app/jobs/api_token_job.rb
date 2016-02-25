class ApiTokenJob < ActiveJob::Base
  queue_as :default

  def perform
    pending_items = Issue.where(api_id: [nil, ''])
    api_items = []
    # Create array of request ids that do not have attributes yet in db
    pending_items.map{ |i|
      unless i.api_token.nil?
        uri = URI("http://test311api.cityofchicago.org/open311/v2/tokens/#{i.api_token}.json")
        response = Net::HTTP.get(uri)
        rjson = JSON.parse(response)[0]
        if rjson.key?("service_request_id")
          i.update(:api_id => rjson["service_request_id"])
          api_items.push(i)
        end
      end
    }

    # For each new id, query the attributes and update the data
    api_items.map{ |r|
      uri = URI("http://test311api.cityofchicago.org/open311/v2/requests/#{r.api_id}.json")
      response = Net::HTTP.get(uri)
      rjson = JSON.parse(response)[0]

      r_seed = {
        api_id: rjson["service_request_id"],
        api_status: rjson["status"],
        api_created_at: rjson["requested_datetime"],
        api_updated_at: rjson["updated_datetime"],
        api_address: rjson["address"],
        api_agency_responsible: rjson["agency_resposible"]
      }

      unless rjson["status_notes"].blank?
        r_seed.merge!(api_status_notes: rjson["status_notes"])
      end

      created_issue = Issue.find_or_create_by(r_seed)

      # Check first to see if the response has a media_url, then remove hosted
      # AWS image and replace URL with API URL
      unless rjson["media_url"].blank?
        created_issue.image.remove_aws_img
        created_issue.image.update(:url => rjson["media_url"])
      end
    }
  end
end
