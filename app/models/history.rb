class History < ActiveRecord::Base



  def self.only_action_types
     find(:all, :select => "action_type").map(&:action_type)  
  end 
  def self.only_remote_ip
     find(:all, :select => "remote_ip").map(&:remote_ip)  
  end 
  def self.only_user_names
     find(:all, :select => "user_name").map(&:user_name)  
  end 

  named_scope :limit, lambda { |num| { :limit => num } }


end
