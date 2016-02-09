class AddIssuepicToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :image_url, :string
  end
end
