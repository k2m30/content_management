class AddUrlToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :url, :string
  end
end
