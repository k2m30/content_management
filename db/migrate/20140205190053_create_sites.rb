class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.text :name
      t.string :css
      t.text :banner

      t.timestamps
    end
  end
end
