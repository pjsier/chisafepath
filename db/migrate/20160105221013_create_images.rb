class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.timestamps
      t.string :image_url
    end
  end
end
