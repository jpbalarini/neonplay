#encoding: utf-8

class SongsController < ApplicationController

  # POST /songs
  def create
    # Get admin_token header
    admin_token = request.headers['admin_token']

    # If it is authorized
    if admin_token.present? && admin_token == ENV['ADMIN_TOKEN']
      # Get song params
      title = params[:title]
      artist = params[:artist]
      album = params[:album]
      price = params[:price]

      # Create song
      song = Song.new(:title => title, :artist => artist, :album => album, :price => price)
      # Try to save song to db
      if song.save
        # If all validations pass
        render json: song.to_json, :status => :created
      else
        # If some validation fails
        render json: song.errors.to_json, :status => :unprocessable_entity
      end
    else
      # Warn user
      render json: {:error => "Your admin_token is not valid or it is not present"}, :status => :unauthorized
    end
  end

  # GET /songs
  def index
    # Get admin_token header
    admin_token = request.headers['admin_token']
    # Get bar_token header
    bar_token = request.headers['bar_token']

    if admin_token.present? && admin_token == ENV['ADMIN_TOKEN']
      # If user is admin
      puts "-----"
      puts "user is admin"
      render json: Song.all.to_json, :status => :ok
    elsif bar_token.present? && Bar.where(token: bar_token).exists?
      # If user is bar owner
      puts "-----"
      puts "user is bar owner"
      render json: Song.all.to_json, :status => :ok
    else
      # User has not provided authentication keys
      # Warn user
      render json: {:error => "Your are not authorized"}, :status => :unauthorized
    end
  end

end
