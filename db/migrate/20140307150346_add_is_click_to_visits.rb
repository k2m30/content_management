class AddIsClickToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :is_click, :boolean, default: false
  end
end
