class CreateTables < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.timestamps
      t.datetime :requested_datetime
      t.datetime :updated_datetime
      t.string :service_request_id
      t.string :status
      t.string :status_notes
      t.string :address
      t.string :description
      t.string :media_url
      t.float  :lon
      t.float  :lat
      t.references :image, index: true
    end

    create_table :images do |t|
      t.string  :url
      t.timestamps
    end
  end
end
