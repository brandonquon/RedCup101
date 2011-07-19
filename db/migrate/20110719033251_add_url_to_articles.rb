class AddUrlToArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do|t|
      t.string :url
      t.string :title
  end

  def self.down
    drop_table :articles
  end
end
