class Jukebox < ActiveRecord::Base
  # Relations
  belongs_to :bar

  # Accesors  
  attr_accessible :url, :volume, :repeat, :bar_id


  # Validations
  validates :volume, :inclusion => 1..10
  validates :url, :presence => {:message => "URL cannot be empty"}, :if => Proc.new { |at| at.url.blank?}
  validates :bar_id, :presence => {:message => "Bar cannot be empty"}, :if => Proc.new { |at| at.bar_id.blank?}
end
