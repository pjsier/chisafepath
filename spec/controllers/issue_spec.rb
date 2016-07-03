require 'rails_helper'

describe IssueController do
  describe "#api_submit" do
    it "submits an issue without image" do
      stub_request(:post, /cityofchicago.org/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: '[
          {
            "token": "577848831c2b95f089312bb2"
          }
        ]', headers: {})

      post :api_submit, issue: {lat: 41, lon: -87, description: "Hazard"}
      expect(response).to redirect_to(:submitted)
    end

    it "handles failure in JSON by including error message in home page" do
      stub_request(:post, /cityofchicago.org/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: '[
          {
            "description": "failed"
          }
        ]', headers: {})

      post :api_submit, issue: {lat: 41, lon: -87, description: "Hazard"}
      expect(response).to render_template(:issue)
    end

    it "handles failure on JSON parsing by including error message in home page" do
      stub_request(:post, /cityofchicago.org/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: 'invalid', headers: {})

      post :api_submit, issue: {lat: 41, lon: -87, description: "Hazard"}
      expect(response).to render_template(:issue)
    end

    # REQUIRES A FILE IN spec/fixtures/fog.yml FOLLOWING THIS FORMAT:
    # default:
    #   aws_access_key_id: XXXX
    #   aws_secret_access_key: XXXX
    #   region: XXXX
    it "submits images in api" do
      stub_request(:post, /cityofchicago.org/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: '[
          {
            "token": "577848831c2b95f089312bb2"
          }
        ]', headers: {})

      issue_img = fixture_file_upload('files/test_image.jpg', 'image/jpg')
      post :api_submit, issue: {lat: 41, lon: -87, description: "Hazard", issuepic: issue_img }
      expect(response).to redirect_to(:submitted)
    end
  end

  describe "#all_open_issues" do
    it "displays all open issues" do
      issues_json = File.read(Rails.root.join('spec/fixtures/all_open_issues.json'))
      issues_parsed = JSON.parse(issues_json)
      issues_parsed.map{ |r|
        i_params = {
          service_request_id: r["service_request_id"],
          status: r["status"],
          lon: r["long"],
          lat: r["lat"],
          requested_datetime: r["requested_datetime"],
          updated_datetime: r["updated_datetime"],
          address: r["address"]
        }
        Issue.find_or_create_from_params(i_params)
      }

      get :all_open_issues
      expect(response).to be_ok
      returned_issues = JSON.parse(response.body)
      expect(returned_issues["features"].length).to eq(3)
    end
  end
end
