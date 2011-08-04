class SearchController < ApplicationController
  def index
    @search = Order.search(params[:search])
    @orders = @search.all
      #@orders = Order.customer_number_like(params[:search].to_s.split)  	  	
  	debugger
  	
  end


  def show
    @order = Order.find(params[:id])
  end



end
