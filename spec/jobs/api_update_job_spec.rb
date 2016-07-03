require 'rails_helper'

describe ApiUpdateJob do
  it "creates issues from API call" do
    stub_request(:get, /cityofchicago.org/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: File.read(Rails.root.join('spec/fixtures/api_response.json')), headers: {})
    ApiUpdateJob.perform_now

    expect(Issue.all.length).to eq(100)
  end
end
