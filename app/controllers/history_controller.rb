class HistoryController < ApplicationController
  
 before_filter :require_admin	
	def index
	  
	@search = History.search(params[:search])
	@search.order ||= :ascend_by_created_at
	
    @history = @search.paginate(:page => params[:page])
		  	
		
	end

end
