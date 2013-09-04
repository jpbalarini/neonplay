class Purchase < ActiveRecord::Base
  # Relations
  belongs_to :bar
  belongs_to :song

  # Accesors
  attr_accessible :bar, :song

  # Validations
  validates :bar_id, :presence => {:message => "Bar cannot be empty"}, :if => Proc.new { |at| at.bar_id.blank?}
  validates :song_id, :presence => {:message => "Song cannot be empty"}, :if => Proc.new { |at| at.song_id.blank?}
end
