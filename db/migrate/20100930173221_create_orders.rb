class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :customer_number
      t.string :first
      t.string :last
      t.string :first_order_number
      t.string :card_type
      t.string :credit_card
      t.date :expected_ship_date
      t.string :exp_month
      t.string :exp_year

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
