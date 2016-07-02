class IssueController < ApplicationController
  def api_submit
    if Rails.env.production?
      uri = URI.parse("http://311api.cityofchicago.org/open311/v2/requests")
      api_key = ENV["CHI_311_KEY"]
    else
      uri = URI.parse("http://test311api.cityofchicago.org/open311/v2/requests")
      api_key = ENV["TEST_311_KEY"]
    end

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)

    api_data = {
      :api_key => api_key,
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

    begin
      response_json = JSON.parse(response)
      if response_json[:token].blank?
        flash[:error] = "There was an error submitting your issue"
        render "home/issue"
      else
        redirect_to submitted_path
      end
    rescue Exception
      flash[:error] = "There was an error submitting your issue"
      render "home/issue"
    end
  end

  def index
  end

  def all_open_issues
    open_issues = Issue.where(status: "open")
    geojson_issues = {
      type: "FeatureCollection",
      features: []
    }
    geojson_issues[:features] = open_issues.map{ |i| i.to_geojson }
    render json: geojson_issues
  end

  private
  def issue_params
    params.require(:issue).permit(:service_request_id,
                                  :status,
                                  :status_notes,
                                  :requested_datetime,
                                  :updated_datetime,
                                  :description,
                                  :media_url,
                                  :address,
                                  :lat,
                                  :lon,
                                  :issuepic)
  end

end
