class CreateTables < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.timestamps
      t.datetime :requested_datetime
      t.datetime :created_datetime
      t.string :service_request_id
      t.string :status
      t.string :status_notes
      t.string :address
      t.string :description
      t.string :media_url
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
