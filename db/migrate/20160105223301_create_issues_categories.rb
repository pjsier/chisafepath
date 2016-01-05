class CreateIssuesCategories < ActiveRecord::Migration
  def self.up
    create_table :issues_categories, :id => false do |t|
      t.references :issue
      t.references :category
    end
    add_index :issues_categories, [:issue_id, :category_id]
    add_index :issues_categories, :category_id
  end

  def self.down
    drop_table :issues_categories
  end
end
