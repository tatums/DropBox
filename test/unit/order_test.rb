require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "must have customer number" do
	o = Order.create(:customer_number => nil, :first=>"Tatum", :last=>"Szymczak", :first_order_number => 12345, :card_type => "visa", :credit_card => "1111222233334444", :expected_ship_date => "12/12/2010", :exp_month => "12", :exp_year => "2010")
	assert o.errors.on(:customer_number)  
  end
  
  
  test "should_create_order" do
	o = Order.create(:customer_number => 36568, :first=>"Tatum", :last=>"Szymczak", :first_order_number => 12345, :card_type => "visa", :credit_card => "1111222233334444", :expected_ship_date => "12/12/2010", :exp_month => "12", :exp_year => "2010")
	assert o.valid?  
  end

  
  
end
