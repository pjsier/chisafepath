class Issue < ActiveRecord::Base
  belongs_to :image

  def self.find_or_create_from_params(issue_params)
    searched_issue = Issue.where(
      service_request_id: issue_params[:service_request_id]
    ).first
    if searched_issue.nil?
      searched_issue = Issue.create(issue_params)
    else
      unless searched_issue.status == issue_params[:status]
        searched_issue.update!(issue_params)
      end
    end
    searched_issue
  end

  def to_geojson
    geojson_issue = {
  		type: "Feature",
  		geometry: {
  			type: "Point",
  			coordinates: [self.lon, self.lat]
  		},
  		properties: {
        status: self.status,
        create_time: self.requested_datetime.strftime("%-m-%-d-%y %I:%M%P"),
        update_time: self.updated_datetime.strftime("%-m-%-d-%y %I:%M%P")
  		}
  	}

    geojson_issue.merge!(image_url: self.media_url) unless self.media_url.blank?
    geojson_issue.merge!(description: self.description) unless self.description.blank?

    geojson_issue
  end
end
