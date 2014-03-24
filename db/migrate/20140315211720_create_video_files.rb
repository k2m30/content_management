class CreateVideoFiles < ActiveRecord::Migration
  def change
    create_table :video_files do |t|
      t.string :internal_name
      t.text :internal_url
      t.string :external_name
      t.text :external_url
      t.string :quality
      t.integer :year
      t.integer :size
      t.belongs_to :content

      t.timestamps
    end
  end
end
