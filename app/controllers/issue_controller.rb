class IssueController < ApplicationController
  def create
    issue = params[:issue]

    uploader = IssuepicUploader.new
    uploader.store!(issue[:issuepic])

    uri = URI.parse("http://test311api.cityofchicago.org/open311/v2/requests.json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)

    # still need to add image url to post if present
    request.set_form_data({
      :api_key => Rails.application.secrets.test_311_key,
      :service_code => "4ffa971e6018277d4000000b",
      :lat => issue[:lat],
      :long => issue[:long],
      "attribute[WHEREIS1]" => "SIDEWALK",
      :description => issue[:issues]
      })

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_token = response_json[0]["token"]

    Issue.create!(
      api_token: response_token,
      description: issue[:issues],
      lonlat: "POINT(#{issue[:long]} #{issue[:lat]})",
      image_url: uploader.url
    )

    # for testing
    # ApiUpdateJob.perform_later()

    render "home/submitted"
  end

  def index
  end

  def get_map_issues
    coords = params[:coords]
    radius_issues = Issue.where("ST_DWithin(lonlat, 'POINT(#{coords[0]} #{coords[1]})', 1000)")
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_issues = radius_issues.map{ |i|
      factory.feature(i.lonlat, i.id, {api_status: i.api_status})
    }
    geoj = RGeo::GeoJSON.encode(factory.feature_collection(geo_issues))
    render json: geoj
  end

  def issue_params
    params.require(:issue).permit(:image_url, :lat, :long, :issues, :issuepic)
  end
end
