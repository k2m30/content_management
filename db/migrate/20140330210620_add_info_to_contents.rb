class AddInfoToContents < ActiveRecord::Migration
  def change
    add_column :contents, :info, :text
    add_column :contents, :description, :text
    add_column :contents, :rating, :text
    add_column :contents, :image, :text
  end
end
