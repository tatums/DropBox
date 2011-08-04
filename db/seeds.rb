# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

u = User.create( :username => 'admin' ,  :first => 'Default' , :email => 'admin@usfood.com', :last => 'Account' , :is_administrator => true , :is_active => true , :password => 'Usfood8p' , :password_confirmation => 'Usfood8p' )

if u.save
	puts "#{u.username} added to the DB"
end
