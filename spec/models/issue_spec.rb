require 'rails_helper'

describe Issue do
  it "should belong to image" do
    issue = Issue.reflect_on_association(:image)
    expect(issue.macro).to eql(:belongs_to)
  end

  it "should create a new issue if one with params does not exist" do
    test_one_params = {
      service_request_id: "test_one",
      status: "open",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "3134 N Clark St"
    }

    expect(Issue.find_or_create_from_params(test_one_params).service_request_id).to eq(test_one_params[:service_request_id])
    expect(Issue.find_or_create_from_params(test_one_params).address).to eq(test_one_params[:address])
  end

  it "should return an existing issue if one is present with same id" do
    test_one_params = {
      service_request_id: "test_issue",
      status: "open",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "3134 N Clark St"
    }
    test_two_params = {
      service_request_id: "test_issue",
      status: "open",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "12345 Fake St"
    }
    # Same service_request_id, so the address should not be changed
    expect(Issue.find_or_create_from_params(test_one_params).address).to eq(test_one_params[:address])
    expect(Issue.find_or_create_from_params(test_two_params).address).to eq(test_one_params[:address])
  end

  it "should update the status of an existing issue if it has changed" do
    test_one_params = {
      service_request_id: "test_issue",
      status: "open",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "3134 N Clark St"
    }
    test_two_params = {
      service_request_id: "test_issue",
      status: "closed",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "3134 N Clark St"
    }

    test_one = Issue.find_or_create_from_params(test_one_params)
    expect(test_one.service_request_id).to eq(test_one_params[:service_request_id])
    expect(test_one.status).to eq("open")

    test_two = Issue.find_or_create_from_params(test_two_params)
    expect(test_two.service_request_id).to eq(test_one_params[:service_request_id])

    # Should return same issue with updated status when status changes
    updated_test_one = Issue.find_by(service_request_id: "test_issue")
    expect(test_two.status).to eq("closed")
    expect(updated_test_one.status).to eq("closed")
  end

  it "should render a response as GeoJSON" do
    test_one_params = {
      service_request_id: "test_issue",
      status: "open",
      lon: -87,
      lat: 41,
      requested_datetime: "2016-06-24T18:27:26-05:00",
      updated_datetime: "2016-06-24T18:19:28-05:00",
      address: "3134 N Clark St"
    }
    test_one = Issue.find_or_create_from_params(test_one_params)

    expect(test_one.to_geojson[:type]).to eq("Feature")
  end
end
