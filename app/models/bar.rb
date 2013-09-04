class Bar < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :purchases
  has_many :songs, :through => :purchases

  attr_accessible :name

  # Validations
  validates :name, :presence => {:message => "Please enter a name"}, :if => Proc.new { |at| at.name.blank?}

  validates_uniqueness_of :name

  # Callbacks
  before_create :generate_token


  ### PROTECTED METHODS ###

  protected

  # Generate token for bar owner authentication
  def generate_token
    # Repeat method until unique token is found
    self.token = loop do
      random_token = (Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")[1..16]
      break random_token unless Bar.where(token: random_token).exists?
    end
  end
end
