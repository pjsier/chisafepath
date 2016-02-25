class Issue < ActiveRecord::Base
  belongs_to :image

  def to_geojson
    factory = RGeo::GeoJSON::EntityFactory.instance
    issue_items = {
      api_status: self.api_status,
      create_time: self.created_at.strftime("%-m-%-d-%y %I:%M%P"),
      update_time: self.updated_at.strftime("%-m-%-d-%y %I:%M%P")
    }
    issue_items.merge!(image_url: self.image.url) unless self.image.blank?

    factory.feature(self.lonlat, self.id, issue_items)
  end
end
