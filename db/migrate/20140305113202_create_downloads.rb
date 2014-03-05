class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.belongs_to :link
      t.datetime :time
      t.string :remote_ip
    end
  end
end
