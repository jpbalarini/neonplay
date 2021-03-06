class Song < ActiveRecord::Base
  # Accesors
  attr_accessible :title, :artist, :album, :price, :length

  # Validations
  validates :title, :presence => {:message => "Please enter a title"}, :if => Proc.new { |at| at.title.blank?}
  validates :artist, :presence => {:message => "Please enter an artist"}, :if => Proc.new { |at| at.artist.blank?}
  validates :album, :presence => {:message => "Please enter an album"}, :if => Proc.new { |at| at.album.blank?}
  validates :price, :presence => {:message => "Please enter a price"}, :if => Proc.new { |at| at.price.blank?}
  validates_numericality_of :price, :greater_than_or_equal_to => 0, :message => "Price must be greater than 0"

  validates_uniqueness_of :title, :scope => [:artist, :album]
end
