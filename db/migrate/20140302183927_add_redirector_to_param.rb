class AddRedirectorToParam < ActiveRecord::Migration
  def change
    add_column :params, :redirector_ip, :string, default: '10.74.0.28'
    add_column :params, :redirector_port, :string, default: '80'
  end
end
