class OrdersController < ApplicationController
 
  def index
  	
    @search = Order.search(params[:search]) 
    @search.order ||= :ascend_by_expected_ship_date
    @orders = @search.paginate(:page => params[:page])
      
    
    @excel_orders = Order.all
    @filename = "future_orders"	
  	make_excel(@excel_orders, @filename)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  def show
    @order = Order.find(params[:id])
  end


  def new
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  def create
    @order = Order.new(params[:order])	
    respond_to do |format|
      if @order.save
      	create_history("New Card entered", "new_card")
        flash[:notice] = 'Thank You.'
        format.html { redirect_to(success_path) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
		    format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  def edit
    @order = Order.find(params[:id]) 
  end
    
  def update
    @order = Order.find(params[:id]) 
    #if @order.save
    if @order.update_attributes(params[:order])
  	  create_history("Modified Customer #{@order.full_name}", "edit_customer")
      flash[:notice] = "Customer updated!"
      redirect_to @order
    else
      render :action => :edit
    end
  end
  
  def process_cc
    @order = Order.find(params[:id])
    @order.processed=true
    @order.processed_by_name = current_user.full_name
    @order.processed_by = current_user
    @order.processed_at = Time.now
    @order.save!
    create_history("Processed Customer #{@order.customer_number}", "processed_card")
    flash[:notice] = "Processed!!"
    redirect_to view_path(@order)
  end
    
    def purge_expired_cards
      @purged_cards = Order.purge_expired_cards
      
    end
    

  #   def future_orders 
  #     @date = Time.now
  #     @orders = Order.future_orders.not_processed.ascend_by_expected_ship_date  
  # @filename = "#{@date}_future_orders"  
  # make_excel(@orders, @filename)
  #   end





protected

  def make_excel(orders,filename)
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet::Workbook.new
		sheet1 = book.create_worksheet  
		@filename = filename
		#FORMATING
		bold = Spreadsheet::Format.new({:weight => :bold, :size => 10} )
		sheet1.column(0).width = 15
		sheet1.column(1).width = 12
		sheet1.column(2).width = 20
		sheet1.column(3).width = 20
		sheet1.column(4).width = 20
		sheet1.column(5).width = 15



		sheet1.row(0).default_format = bold
		sheet1[0,0] = 'Customer Number' 
		sheet1[0,1] = 'First Name' 
		sheet1[0,2] = 'Last Name'
		sheet1[0,3] = 'Expected Ship Date'
		sheet1[0,4] = 'First Order Number'
		sheet1[0,5] = 'Card Processed'

		i = 1
		orders.each do |order| 
	        sheet1.row(i).concat [order.customer_number.to_i, 
	        		order.first, 
	        		order.last,
	        		order.expected_ship_date.to_s(:long), 
	        		order.first_order_number.to_i,
	        		order.processed
        		 ]
	        
	        i = i + 1
		end
		book.write "#{RAILS_ROOT}/public/data/#{filename}.xls"
  end

    
    
    
    
    
end
