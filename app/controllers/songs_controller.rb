#encoding: utf-8

class SongsController < ApplicationController
  before_filter :authorize_admin, :only => [:create]
  before_filter :authorize_admin_or_bar_owner, :only => [:index, :on_sale]

  # POST /songs
  def create
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
  end

  # GET /songs
  def index
    # Get all songs
    render json: Song.all.to_json, :status => :ok
  end

  # GET /songs/on_sale
  def on_sale
    # Get songs on sale
    render json: Song.where(["price <= ?", 1.0]).to_json, :status => :ok
  end

  ### PROTECTED METHODS ###
  protected

  def authorize_admin
    # Get admin_token header
    admin_token = request.headers['admin_token']
    if admin_token.present? && admin_token == ENV['ADMIN_TOKEN']
      true
    else
      render json: {:error => "Your admin_token is not valid or it is not present"}, :status => :unauthorized
      false
    end
  end

  def authorize_admin_or_bar_owner
    # Get admin_token header
    admin_token = request.headers['admin_token']
    # Get bar_token header
    bar_token = request.headers['bar_token']

    if admin_token.present? && admin_token == ENV['ADMIN_TOKEN']
      true
    elsif bar_token.present? && Bar.where(token: bar_token).exists?
      true
    else
      render json: {:error => "Either your admin_token or bar_token is not valid or not present"}, :status => :unauthorized
      false
    end
  end

end
