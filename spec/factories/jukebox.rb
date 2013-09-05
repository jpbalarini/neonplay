require 'factory_girl'

FactoryGirl.define do
	factory :jukebox do  		
		url "http://0.0.0.0:9292"
		volume 5
		association(:bar) 
  	end
end

