class Issue < ActiveRecord::Base
  belongs_to :image

  def to_geojson
    factory.feature(i.lonlat, i.id, { api_status: i.api_status,
                                      create_time: i.created_at.strftime("%-m-%-d-%y %I:%M%P"),
                                      update_time: i.updated_at.strftime("%-m-%-d-%y %I:%M%P"),
                                      image_url: i.image_url })
  end
end
