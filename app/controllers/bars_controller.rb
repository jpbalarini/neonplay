#encoding: utf-8

class BarsController < ApplicationController
  before_filter :authorize_bar_owner, :only => [:songs]

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
      render json: {:error => bar.errors}, :status => :unprocessable_entity
    end
  end

  # POST /bars/:id/songs
  def songs
    # Method to buy songs for a bar
    song = Song.where(:id => params[:song_id]).first()
    bar = Bar.where(:token => request.headers['bar_token']).first()

    if song.present? and bar.present?
      purchase = Purchase.new(:song => song, :bar => bar)
      if purchase.save
        render json: song.to_json, :status => :ok
      else
        render json: {:error => "Could not save your purchase"}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar and song"}, :status => :unprocessable_entity
    end
  end

  ### PROTECTED METHODS ###
  protected

  def authorize_bar_owner
    # Get bar_token header
    bar_token = request.headers['bar_token']
    if bar_token.present? && Bar.where(token: bar_token).exists?
      true
    else
      render json: {:error => "Your bar_token is not valid or it is not present"}, :status => :unauthorized
      false
    end
  end

end
