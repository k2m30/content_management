class CreateSpnukeFiles < ActiveRecord::Migration
  def change
    create_table :spnuke_files do |t|
      t.integer :files_id
      t.integer :files_cat_id
      t.string :files_title
      t.text :files_url
      t.text :files_description
      t.datetime :files_date
      t.decimal :files_size
      t.string :files_server
      t.integer :files_id_serial
      t.integer :year
      t.string :quality
      t.string :remote_url
      t.string :remote_name
    end
  end
end
