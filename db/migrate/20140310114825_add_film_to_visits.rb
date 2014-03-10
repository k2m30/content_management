class AddFilmToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :film, :string
  end
end
