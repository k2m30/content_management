class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.belongs_to :site
      t.belongs_to :content
      t.timestamps
    end
  end
end
