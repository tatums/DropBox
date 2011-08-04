class AdministratorController < ApplicationController
	
	 before_filter :require_user

  def index
    
  	@search = Order.search(params[:search])
  	@search.order ||= :ascend_by_expected_ship_date
    @orders = @search.paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  def show
    @order = Order.find(params[:id])
    create_history("Viewed  Customer #{@order.customer_number}", "view")
  end


  def encrypted_cards
  	@orders = Order.all
  end
  
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    create_history("Deleted  Customer #{@order.customer_number}", "delete")
    flash[:warning] = "Deleted  Customer #{@order.customer_number}"
    
    respond_to do |format|
      format.html { redirect_to(admin_url) }
      format.xml  { head :ok }
    end
  end
  
  
  private
   def authenticate
      authenticate_or_request_with_http_basic do |id, password| 
          id == USER_ID && password == HASH
      end
   end

end
