class AddIssuepicToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :issuepic, :string
  end
end
