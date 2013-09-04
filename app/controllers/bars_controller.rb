#encoding: utf-8

class BarsController < ApplicationController

  # POST /bars
  def create
    # Get bar params
    name = params[:name]

    # Create bar
    bar = Bar.new(:name => name)
    # Try to save bar to db
    if bar.save
      # If all validations pass
      render json: bar.to_json, :status => :created
    else
      # If some validation fails
      render json: bar.errors.to_json, :status => :unprocessable_entity
    end
  end
  
end
