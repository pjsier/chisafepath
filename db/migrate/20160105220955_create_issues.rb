class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.timestamps
      t.string :api_id
      t.string :api_token
      t.string :api_status
      t.string :service_code
      t.string :description
      t.string :image_url
      t.st_point :lonlat, geographic: true
    end
  end
end
