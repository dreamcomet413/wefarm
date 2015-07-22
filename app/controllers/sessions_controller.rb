class SessionsController < ApplicationController
  def new
  end

  # POST /sessions
  def create
    farmer = Farmer.authenticate params[:email], params[:password]
      if farmer
        session[:farmer_id] = farmer.id
        redirect_to root_path, :notice => "Welcome back to WeFarm"
      else
        redirect_to :login, :alert => "Invalid email or password"
      end
  end

  def destroy
    session[:farmer_id] = nil
    redirect_to root_path :notice => "You have been logged out"
  end
end
