# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  helper_method :remote_ip
  before_filter :fetch_remote_ip
	
  
    helper_method :current_user_session, :current_user, :remote_ip
  	filter_parameter_logging :password, :password_confirmation
    before_filter :fetch_remote_ip


protected

	def create_history(body, action)
		@history = History.new
		@history.user_id = 0
		@history.user_name = "not logged in"
		if current_user
			@history.user_id = current_user.id
			@history.user_name = current_user.full_name
		end
	    @history.body = body
	    @history.action_type = action
	    @history.remote_ip = @remote_ip
	    @history.save
	end


	helper_method :is_admin
	
	def is_admin
		return true if current_user.is_administrator == true
	end		




	private   
  
  
	def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def current_admin
      return @current_user if defined?(@current_user) 
      @current_user = current_user_session && current_user_session.record
    end

    
    def require_user
      unless current_user
        store_location
        flash[:warning] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_admin
    	if current_user.nil? or current_user.is_administrator == false
	    	store_location
	    	if current_user.nil?
	    	  flash[:notice] = "You must be logged in to access this page"
	      else
	        flash[:warning] = "You don't have the proper authorization"
	      end
	      redirect_to login_url
	      return false
  	  end	
    end	
    
    # def require_admin
    #   unless current_user.is_administrator == true
    #         store_location
    #         flash[:notice] = "Sorry, Your credentials don't have authorization."
    #           redirect_to login_url
    #           return false
    #   end 
    # end 

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    
    
    def fetch_remote_ip
	  @remote_ip = request.remote_ip
	end	

  
  
end
