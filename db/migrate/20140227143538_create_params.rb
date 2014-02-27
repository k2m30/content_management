class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :outgrader_ip, default: '127.0.0.1'
      t.string :outgrader_port, default: '8080'
      t.string :outgrader_status, default: 'stopped'
      t.timestamps
    end
  end
end
