class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_admin#, :only => [:show, :edit, :update]
  
  def index
  	@users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
	  create_history("Created a new account for #{@user.full_name}", "new_account")
      flash[:notice] = "Account registered!"
      redirect_to users_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    
  end
  
  def update
    @user = User.find(params[:id]) 
    if @user.update_attributes(params[:user])
  	  create_history("Modified user account #{@user.full_name}", "edit_account")
      flash[:notice] = "Account updated!"
      redirect_to users_url
    else
      render :action => :edit
    end
  end



 def enable_disable
	@user = User.find(params[:id])
	if @user.is_active == true
		@user.is_active = false
	else
		@user.is_active = true
	end
	redirect_to users_url
 end



end
