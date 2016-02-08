class IssueController < ApplicationController
  def create
    issue = params[:issue]

    uri = URI.parse("http://test311api.cityofchicago.org/open311/v2/requests.json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)


    request.set_form_data({
      :api_key => Rails.application.secrets.test_311_key,
      :service_code => "4ffa971e6018277d4000000b",
      :lat => issue[:lat],
      :long => issue[:long],
      "attribute[WHEREIS1]" => "SIDEWALK",
      :description => issue[:issues].join(", ")
      })

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_token = response_json[0]["token"]

    Issue.create!(
      api_token: response_token,
      description: issue[:issues].join(", "),
      lonlat: "POINT(#{issue[:long]} #{issue[:lat]})"
    )

    # for testing
    # ApiUpdateJob.perform_later()

    render json: { token: response_json[0]["token"] }
  end

  def index
  end

  def issue_params
    params.require(:issue).permit(:img_id, :img_url, :lat, :long, :issues)
  end
end
