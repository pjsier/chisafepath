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

    it "handles failure by including error message in home page" do
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
  end
end
