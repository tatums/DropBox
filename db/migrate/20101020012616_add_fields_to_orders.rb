class AddFieldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :processed, :boolean, :default => false
    add_column :orders, :processed_by_name, :string
    add_column :orders, :processed_by, :integer
    add_column :orders, :processed_at, :datetime 
    
  end

  def self.down
    remove_column :orders, :processed, :boolean, :default => false
    remove_column :orders, :processed_by_name, :string
    remove_column :orders, :processed_by, :integer    
    remove_column :orders, :processed_at, :datetime 
    
  end
end
