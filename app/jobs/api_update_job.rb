class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform
    if Rails.env.production?
      api_url = "http://311api.cityofchicago.org/open311/v2/requests.json"
    else
      api_url = "http://test311api.cityofchicago.org/open311/v2/requests.json"
    end
    
    uri = URI("#{api_url}?service_code=4ffa971e6018277d4000000b&page_size=200")
    response = Net::HTTP.get(uri)
    response_json = JSON.parse(response)

    response_json.map{ |r|
      unless Issue.exists?(api_id: r["service_request_id"])
        r_seed = {
          api_id: r["service_request_id"],
          api_status: r["status"],
          lonlat: "POINT(#{r["long"]} #{r["lat"]})",
          api_created_at: r["requested_datetime"],
          api_updated_at: r["updated_datetime"],
          api_address: r["address"],
          api_agency_responsible: r["agency_resposible"]
        }

        unless r["media_url"].blank?
          api_img = Image.find_or_create_by(url: r["media_url"])
          r_seed.merge!(image_id: api_img.id)
        end

        unless r["status_notes"].blank?
          r_seed.merge!(api_status_notes: r["status_notes"])
        end

        Issue.find_or_create_by(r_seed)
      end
    }
  end

end
