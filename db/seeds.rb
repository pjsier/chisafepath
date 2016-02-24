# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

uri = URI("http://311api.cityofchicago.org/open311/v2/requests.json?service_code=4ffa971e6018277d4000000b&page_size=200")
#puts uri
response = Net::HTTP.get(uri)
#puts response
response_json = JSON.parse(response)
response_json.map{ |r|
  dummy_img = nil
  unless r["media_url"].blank?
    dummy_img = r["media_url"]
  end

  unless Issue.exists?(api_id: r["service_request_id"])
    issue = Issue.find_or_create_by(api_id: r["service_request_id"],
                                    api_status: r["status"],
                                    service_code: r["service_code"],
                                    lonlat: "POINT(#{r["long"]} #{r["lat"]})",
                                    image_url: dummy_img)
  end
}
=begin
resource_path = "db"
json_file = File.read(Rails.root.join(resource_path, "311_pave.json"))
json_data = JSON.parse(json_file)

json_data.each do |pave_data|
  dummy_img = nil
  unless pave_data["media_url"].blank?
    dummy_img = pave_data["media_url"]
  end
  Issue.find_or_create_by(api_id: pave_data["service_request_id"],
                          api_status: pave_data["status"],
                          service_code: pave_data["service_code"],
                          lonlat: "POINT(#{pave_data["long"]} #{pave_data["lat"]})",
                          image_url: dummy_img)
end
=end
