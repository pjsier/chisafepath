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
      :api_key => Rails.application.secrets.chi_311_key,
      :service_code => "4ffa971e6018277d4000000b",
      :lat => issue_params[:lat],
      :long => issue_params[:long],
      "attribute[WHEREIS1]" => "SIDEWALK",
      :description => issue_params[:description]
    }

    issue_data = {
      description: issue_params[:description],
      lonlat: "POINT(#{issue_params[:long]} #{issue_params[:lat]})"
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

  def get_map_issues
    coords = params[:coords]
    radius_issues = Issue.where(
      "ST_DWithin(lonlat, 'POINT(#{coords[0]} #{coords[1]})', 1000) AND status = 'open'"
      )
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_issues = radius_issues.map{ |i| i.to_geojson }
    geoj = RGeo::GeoJSON.encode(factory.feature_collection(geo_issues))
    render json: geoj
  end

  def all_open_issues
    open_issues = Issue.where(status: "open")
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_issues = open_issues.map{ |i| i.to_geojson }
    geoj = RGeo::GeoJSON.encode(factory.feature_collection(geo_issues))
    render json: geoj
  end

  private
  def issue_params
    params.require(:issue).permit(:service_request_id, :status, :status_notes,
                                  :requested_datetime, :updated_datetime,
                                  :description, :media_url, :address, :lat, :long,
                                  :lonlat)
  end

end
