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
    factory = RGeo::GeoJSON::EntityFactory.instance
    issue_items = {
      status: self.status,
      create_time: self.requested_datetime.strftime("%-m-%-d-%y %I:%M%P"),
      update_time: self.updated_datetime.strftime("%-m-%-d-%y %I:%M%P")
    }
    issue_items.merge!(image_url: self.media_url) unless self.media_url.blank?

    factory.feature(self.lonlat, self.id, issue_items)
  end
end
