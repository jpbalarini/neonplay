#encoding: utf-8
require 'json'

class BarsController < ApplicationController
  before_filter :authorize_bar_owner, :only => [:songs, :jukebox]

  # POST /bars
  def create

    # Create bar
    bar = Bar.new(params[:bar])
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
    bar = Bar.where(:id => params[:id]).first()

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

  #PUT /bars/:id/jukebox
  def jukebox
    # Get bar 
    bar = Bar.where(:id => params[:id]).first()

    if bar.present?
      jukebox = Jukebox.new(params[:jukebox])
      jukebox.bar = bar
      if jukebox.save
        client = NeonPlayJukebox.connect(bar.jukebox.url)
        client.volume(bar.jukebox.volume)
        render json: jukebox.to_json, :status => :ok
      else
        render json: {:error => jukebox.errors}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar"}, :status => :unprocessable_entity
    end
  end

  # GET /bars/:id/jukebox
  def jukebox_info
    # Get bar
    bar = Bar.where(:id => params[:id]).first()

    if bar.present?
      if bar.jukebox.present?
        client = NeonPlayJukebox.connect(bar.jukebox.url)
        result = {}
        result["url"] = bar.jukebox.url
        result["repeat"] = bar.jukebox.repeat
        result["volume"] = bar.jukebox.volume
        if client.playing?
          song_id = JSON.parse(bar.jukebox.playlist)[0]
          song = Song.where(:id => song_id).first()
          if song.present?
            result["current_song"] = song.to_json
          end
        end

        render json: result.to_json, :status => :ok
      else
        render json: {:error => "Bar has no associated jukebox"}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar"}, :status => :unprocessable_entity
    end
  end

  # POST /bars/:id/jukebox/songs
  def add_song
    # Get bar and song
    bar = Bar.where(:id => params[:id]).first()
    song = Song.where(:id => params[:song_id]).first()

    if song.present? and bar.present?
      if bar.jukebox.present?
        purchase = Purchase.where(:bar_id => bar.id, :song_id => song.id).first()
        # If this bar purchased this song
        if purchase.present?  
          # Get jukebox playlist, it's an array of songs ids
          playlist = bar.jukebox.playlist
          if playlist.blank?
            # Update playlist
            playlist = []
          else
            playlist = JSON.parse(playlist)
          end

          playlist << song.id
          bar.jukebox.playlist = playlist.to_json
          bar.jukebox.save!

          # If client is idle, send song to jukebox
          client = NeonPlayJukebox.connect(bar.jukebox.url)
          if client.idle?
            client.play(song, ENV['NEONPLAY_URL'] + '/bars/' + bar.id.to_s + '/songs_callback')
          end

          render json: {}, :status => :ok
        else
          render json: {:error => "You must purchase this song first"}, :status => :unprocessable_entity
        end
      else
        render json: {:error => "Bar has no associated jukebox"}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar and song"}, :status => :unprocessable_entity
    end
  end

  # GET /bars/:id/jukebox/songs
  def jukebox_songs
    # Get bar
    bar = Bar.where(:id => params[:id]).first()
    result = []
    if bar.present?
      if bar.jukebox.present?
        playlist = bar.jukebox.playlist
        if playlist.blank?
          playlist = []
        else
          playlist = JSON.parse(playlist)
        end

        songs = Song.find_all_by_id(playlist)
        songs.each.map do |s|
          result << s.as_json
        end

        render json: result.to_json, :status => :ok
      else
        render json: {:error => "Bar has no associated jukebox"}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar"}, :status => :unprocessable_entity
    end
  end

  # POST /bars/:id/songs_callback
  def songs_callback
    # Get the bar id
    bar = Bar.where(:id => params[:id]).first()
    result = []

    if bar.present?
      if bar.jukebox.present?
        # Get current playlist
        playlist = bar.jukebox.playlist
        if playlist.blank?
          playlist = []
        else
          playlist = JSON.parse(playlist)
        end

        # If servers is on repeat mode
        if bar.jukebox.repeat

        else
          # Remove oldest song from playlist. Update playlist
          bar.jukebox.playlist = playlist[1..-1].to_json
          bar.jukebox.save!
          # Send next song to jukebox
          song = Song.where(:id => playlist[1]).first()
          if song.present?
            client = NeonPlayJukebox.connect(bar.jukebox.url)
            client.play(song, ENV['NEONPLAY_URL'] + '/bars/' + bar.id.to_s + '/songs_callback')
          end
        end

        

        render json: {}, :status => :ok
      else
        render json: {:error => "Bar has no associated jukebox"}, :status => :unprocessable_entity
      end
    else
      render json: {:error => "You must provide a valid bar"}, :status => :unprocessable_entity
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
