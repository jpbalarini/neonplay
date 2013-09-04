class Purchase < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :bar
  belongs_to :song
end
