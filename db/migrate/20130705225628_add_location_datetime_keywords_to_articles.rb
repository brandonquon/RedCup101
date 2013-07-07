class AddLocationDatetimeKeywordsToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :location, :string
    add_column :articles, :datetime, :datetime
    add_column :articles, :keywords, :string
  end

  def self.down
    remove_column :articles, :keywords
    remove_column :articles, :datetime
    remove_column :articles, :location
  end
end
