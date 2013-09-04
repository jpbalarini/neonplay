#encoding: utf-8

class SongsController < ApplicationController
  #render layout: false

  # POST /songs
  def create
    admin_token = request.headers['admin_token']

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
      render json: "Your admin_token is not valid or it is not present", :status => :unprocessable_entity
    end

    

  end

end
