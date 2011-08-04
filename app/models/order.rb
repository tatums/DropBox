class Order < ActiveRecord::Base


  belongs_to :processed_by, :class_name => "User", :foreign_key => "processed_by"



# pagination 
  cattr_reader :per_page
  @@per_page = 30
 
#encrypts after validations occur but before saving to the db
  before_save :encrypt_card_number
  


   validates_presence_of  :customer_number, :first, :last,  :credit_card, :exp_month, :exp_year, :expected_ship_date, :card_type
   validates_numericality_of :customer_number
     
   validate :credit_card_must_be_valid
   validate :check_if_card_is_expired
   validate :card_must_not_expire_before_ship_date
#   validate :check_if_expected_ship_date_is_in_the_past
#validate :credit_card_types_must_match




#not sure if I will still need these
def formatted_created_at
  self.created_at.to_date.to_s(:long)
end

def formatted_expected_ship_date
  self.expected_ship_date.to_date.to_s(:long)
end


#this is a method to help with IE.  It doesn't display the border without content.
def first_order(order)
		if self.first_order_number.empty?
			return '&nbsp;'
		else
			return first_order_number	
		end	
end

#--------------------------------------------

def self.only_created_at
  # find(:all, :select => "created_at").map(&:formatted_created_at).insert(0," ").uniq  
  find(:all, :select => "created_at").map(&:created_at).insert(0," ").uniq  
end 

def self.only_expected_ship_date
   find(:all, :select => "expected_ship_date").map(&:formatted_expected_ship_date).insert(0," ").uniq  
end 


PROCESSED = [
  ['', ''],
    ["true", true],
    ["false", false]
  ]

  CARD_TYPE = [
    # Displayed   ,  Stored in DB
    [ "Visa"  , "visa"   ],
    [ "Mastercard" , "mastercard"  ] ,
	[ "American Express" ,  "amex"]
  ]

  MONTH = [
    # Displayed   ,  Stored in DB
    [ "1 - JAN"  , "01"   ],
    [ "2 - FEB" , "02"  ] ,
	[ "3 - MAR" ,  "03"],
    [ "4 - APR" ,  "04"],
	[ "5 - MAY" ,  "05"],
	[ "6 - JUN" ,  "06"],
	[ "7 - JUL" ,  "07"],
	[ "8 - AUG" ,  "08"],
	[ "9 - SEPT" ,  "09"],
	[ "10 - OCT" ,  "10"],
	[ "11 - NOV" ,  "11"],
	[ "12 - DEC" ,  "12"]
]


  YEAR = [
    # Displayed   ,  Stored in DB
  [ Date.today.year  , Date.today.year   ],
  [ Date.today.year+1 , Date.today.year+1  ] ,
	[ Date.today.year+2 ,  Date.today.year+2],
	[ Date.today.year+3 ,  Date.today.year+3],
	[ Date.today.year+4 ,  Date.today.year+4]

    ]



    named_scope :not_prcessed, :conditions => {:processed => false}
    named_scope :not_prcessed, :conditions => {:processed => true}
    named_scope :future_orders, lambda { {:conditions =>['expected_ship_date > ?', Time.now.to_date ] } }

    named_scope :old_orders, lambda { {:conditions =>['expected_ship_date < ?', Time.now.to_date ] } }

      
    def full_name
      first+" "+last
    end
    

    def decrypted_card_number
		 	@priv_key = Crypto::Key.from_file('rsa_key')
		  	c = @priv_key.decrypt(credit_card) 
		 	return c
		end
		
	def decrypted_cc_with_dashes
		x=decrypted_card_number
		v = x[0,4] + "-" + x[4,4] + "-" + x[8,4] + "-" + x[12,4]
		return v
	end
	
	def last_four
	  x=decrypted_card_number
		v = "XXXX" + "-" + "XXXX" + "-" + "XXXX" + "-" + x[12,4]
		return v
	end

	def expired?
		t = Time.now
		ex = Date.new(exp_year.to_i, exp_month.to_i)
  		ex = ex+1.month
  		ex = ex-1.day
	  	if t < ex then 
	  	  return false 
	  	else 
	  	  return true 
	  	end 
	end



    
 protected


 def self.purge_expired_cards
   n = 0 
   @orders = Order.all
   @orders.each do |order|
     if order.expired?
       n+=1
       order.destroy
     end
   end
   return n
 end





  def credit_card_must_be_valid
    unless encrypted? || credit_card.nil?
    c = CreditCard.new(credit_card)
    errors.add(:credit_card, 'card needs to be valid') unless c.valid? 
    end
  end


  def card_must_not_expire_before_ship_date
  	unless exp_year.blank? || exp_month.blank? || expected_ship_date.nil? 
  		d = Date.new(exp_year.to_i, exp_month.to_i)
  		d = d+1.month
    	d = d-1.day
		errors.add(:expected_ship_date, '... The credit card will expire prior to billing. Please get a different Credit Card.') if d < expected_ship_date 
 	end
  end
 
  def check_if_card_is_expired
    unless exp_year.empty? || exp_month.empty?
    	ex = Date.new(exp_year.to_i, exp_month.to_i)
    	ex = ex+1.month
    	ex = ex-1.day
    	d = Date.today
      errors.add(:exp_month, 'is not valid.  Credit Card is expired') if ex < d
    end
  end
  
  def check_if_expected_ship_date_is_in_the_past
    unless expected_ship_date.nil?
    errors.add(:expected_ship_date, 'cannot occur in the past') if expected_ship_date<Time.now.to_date 
    end
  end

private

    def encrypt_card_number
      unless encrypted?
      @pub_key =  Crypto::Key.from_file('rsa_key.pub')
      self.credit_card = @pub_key.encrypt(credit_card)
      end
    end

  def encrypted?
    unless credit_card.nil?
	  	if credit_card.size > 50
	      return true
		end
	 end
	return false	
end


end
