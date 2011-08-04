require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'development.sqlite3',
  :host     => 'localhost')



class Order < ActiveRecord::Base
  belongs_to :processed_by, :class_name => "User", :foreign_key => "processed_by"
  named_scope :old_orders, lambda { {:conditions =>['expected_ship_date < ?', Time.now.to_date ] } }
end


s = Order.old_orders.size  
Order.old_orders.delete_all
puts "#{s} records were purged from the DataBase."