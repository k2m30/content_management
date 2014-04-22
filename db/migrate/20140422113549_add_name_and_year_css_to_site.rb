class AddNameAndYearCssToSite < ActiveRecord::Migration
  def change
    add_column :sites, :name_css, :string
    add_column :sites, :year_css, :string
  end
end
