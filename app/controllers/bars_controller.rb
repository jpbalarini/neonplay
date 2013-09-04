class BarsController < ApplicationController
  
  def index
    render :text => ENV["ADMIN_TOKEN"]
  end
end
