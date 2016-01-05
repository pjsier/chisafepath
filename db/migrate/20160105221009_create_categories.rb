class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.timestamps
      t.string :name
    end
  end
end
