class CreateTables < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.timestamps
      t.datetime :api_created_at
      t.datetime :api_updated_at
      t.string :api_id
      t.string :api_token
      t.string :api_status
      t.string :api_status_notes
      t.string :api_address
      t.string :api_agency_responsible
      t.string :description
      t.st_point :lonlat, geographic: true
      t.index :lonlat, using: :gist
      t.references :image, index: true
    end

    create_table :images do |t|
      t.string  :url
      t.timestamps
    end

    create_table :locations do |t|
      t.timestamps
      t.string :name
      t.string :level
      t.geometry :geom
      t.index :geom, using: :gist
    end
  end
end
