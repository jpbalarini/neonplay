class Bar < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :purchases
  has_many :songs, :through => :purchases
end
