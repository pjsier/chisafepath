class IssueController < ApplicationController
  def create
    issue = params[:issue]

    uri = URI.parse("http://test311api.cityofchicago.org/open311/v2/requests.json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)

    api_data = {
      :api_key => Rails.application.secrets.test_311_key,
      :service_code => "4ffa971e6018277d4000000b",
      :lat => issue[:lat],
      :long => issue[:long],
      "attribute[WHEREIS1]" => "SIDEWALK",
      :description => issue[:description]
    }

    uploaded_url = nil

    unless issue[:issuepic].blank?
      uploader = IssuepicUploader.new
      uploader.store!(issue[:issuepic])
      uploaded_url = uploader.url
      api_data[:media_url] = uploaded_url
    end

    # still need to add image url to post if present
    request.set_form_data(api_data)

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_token = response_json[0]["token"]

    Issue.create!(
      api_token: response_token,
      description: issue[:description],
      lonlat: "POINT(#{issue[:long]} #{issue[:lat]})",
      image_url: uploaded_url
    )

    redirect_to submitted_path
  end

  def index
  end

  def get_map_issues
    coords = params[:coords]
    radius_issues = Issue.where("ST_DWithin(lonlat, 'POINT(#{coords[0]} #{coords[1]})', 1000)")
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_issues = radius_issues.map{ |i|
      factory.feature(i.lonlat, i.id, { api_status: i.api_status,
                                        create_time: i.created_at.strftime("%-m-%-d-%y %I:%M%P"),
                                        update_time: i.updated_at.strftime("%-m-%-d-%y %I:%M%P"),
                                        image_url: i.image_url })
    }
    geoj = RGeo::GeoJSON.encode(factory.feature_collection(geo_issues))
    render json: geoj
  end

  def issue_params
    params.require(:issue).permit(:image_url, :description, :issuepic, :description, :lat, :long)
  end
end
