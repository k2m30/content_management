class AddRegexpToSite < ActiveRecord::Migration
  def change
    add_column :sites, :regexp, :string
  end
end
