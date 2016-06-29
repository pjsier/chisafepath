class IssueController < ApplicationController
  def api_submit
    if Rails.env.production?
      uri = URI.parse("http://311api.cityofchicago.org/open311/v2/requests")
    else
      uri = URI.parse("http://test311api.cityofchicago.org/open311/v2/requests")
    end

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)

    api_data = {
      :api_key => ENV["CHI_311_KEY"],
      :service_code => "4ffa971e6018277d4000000b",
      :lat => issue_params[:lat],
      :long => issue_params[:lon],
      "attribute[WHEREIS1]" => "SIDEWALK",
      :description => issue_params[:description]
    }

    issue_data = {
      description: issue_params[:description],
      lon: issue_params[:lon],
      lat: issue_params[:lat]
    }

    unless issue_params[:issuepic].blank?
      post_img = Image.create_from_upload(issue_params[:issuepic])
      api_data.merge!(:media_url => post_img.url)
      issue_data.merge!(:image_id => post_img.id)
    end

    request.set_form_data(api_data)

    response = http.request(request)

    redirect_to submitted_path
  end

  def index
  end

  def all_open_issues
    open_issues = Issue.where(status: "open")
    geojson_issues = {
      type: "FeatureCollection",
      features: []
    }
    # factory = RGeo::GeoJSON::EntityFactory.instance
    geojson_issues[:features] = open_issues.map{ |i| i.to_geojson }
    #geoj = RGeo::GeoJSON.encode(factory.feature_collection(geo_issues))
    render json: geojson_issues
  end

  private
  def issue_params
    params.require(:issue).permit(:service_request_id, :status, :status_notes,
                                  :requested_datetime, :updated_datetime,
                                  :description, :media_url, :address, :lat, :lon,
                                  :issuepic)
  end

end
