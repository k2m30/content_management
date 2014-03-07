class RenameDownloadToVisit < ActiveRecord::Migration
  def change
    rename_table :downloads, :visits
  end
end
