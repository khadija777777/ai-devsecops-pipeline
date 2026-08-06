class AddSecurityFieldsToAds < ActiveRecord::Migration[8.1]
  def change
    add_column :ads, :ip_address, :string
    add_column :ads, :operating_system, :string
    add_column :ads, :criticality, :string
    add_column :ads, :status, :string
    add_column :ads, :last_scan_at, :datetime
  end
end
