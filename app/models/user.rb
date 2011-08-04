class User < ActiveRecord::Base


  has_many :processed_cards, :class_name => "Order", :foreign_key => "processed_by"



	validates_presence_of :first, :last
	acts_as_authentic do |c|
      c.logged_in_timeout = 1.day 
    end # the configuration block is optional
    
  def full_name
		first + " " + last
	end
  
  
  
end
