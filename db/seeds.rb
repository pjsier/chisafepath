# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

resource_path = "db"
json_file = File.read(Rails.root.join(resource_path, "311_pave.json"))
json_data = JSON.parse(json_file)

json_data.each do |pave_data|
  issue = Issue.find_or_create_by(api_id: pave_data["service_request_id"],
                                  api_status: pave_data["status"],
                                  service_code: pave_data["service_code"],
                                  lonlat: "POINT(#{pave_data["long"]} #{pave_data["lat"]})")
end
