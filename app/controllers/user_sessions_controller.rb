class UserSessionsController < ApplicationController
	
	def new
		@user_session = UserSession.new  
	end

	def create   
		@user_session = UserSession.new(params[:user_session])
  		if @user_session.save   
  			create_history("LOG IN", "login")
    		flash[:notice] = "Successfully logged in."  
    		redirect_back_or_default(root_url)   
  		else  
    		render :action => 'new'  
  		end  
	end  


	def destroy   
  	  create_history("LOG OUT", "logout")
	  @user_session = UserSession.find   
	  @user_session.destroy   
	  flash[:notice] = "Successfully logged out."  
	  redirect_to root_url   
	end  

end